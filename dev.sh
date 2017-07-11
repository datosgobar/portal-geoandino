#!/bin/bash

ProgName=$(basename $0);
geoandino_name="geonode";
db_name="db";

sub_help(){
    echo "Uso: $ProgName <subcomando>"
    echo "Subcomandos:"
    echo "    up                    Levantar la aplicacion (Regenerar si es necesario)"
    echo "    migrate               Migrar la base de datos"
    echo "    createadmin           Crear un usuario administrador (admin)"
    echo "    test                  Correr los tests de la aplicacion"
    echo "    restart               Reiniciar el servicor geonode"
    echo "    down                  Borrar la aplicacion y sus datos"
    echo "    cp <file> <dest>      Copiar archivo dentro del contenedor de geonode"
    echo "    console               Entrar en la consola del contenedor de geonode"
    echo "    sync                  Sincronizar el theme (../geoandino-theme) con el container"
    echo "    db_cp <file> <dest>   Copiar archivo dentro del contenedor de la base de datos"
    echo "    db_console            Entrar en la consola del contenedor de la base de datos"
    echo ""
}

sub_up(){
    docker-compose -f dev.yml up --build -d;
}
  
sub_down(){
    docker-compose -f dev.yml down -v;
}

sub_restart() {
    docker-compose -f dev.yml restart $geoandino_name;
}

sub_exec() {
    docker-compose -f dev.yml exec $geoandino_name $@;
}

sub_db_exec() {
    docker-compose -f dev.yml exec $db_name $@;
}

sub_createadmin() {
    sub_exec python manage.py createsuperuser --username admin --email admin@admin.com;
}

sub_migrate(){
    sub_exec python manage.py migrate;
}

sub_test() {
    sub_exec python manage.py test;
}

sub_console() {
    sub_exec bash;
}

sub_link() {
    sub_exec bash /home/geonode/bins/link_settings.sh
}

sub_collectstatic(){
    sub_exec python manage.py collectstatic --noinput
    sub_exec chown -R www-data:www-data /home/geonode/static_root/
}

sub_db_console() {
    sub_db_exec bash
}

sub_db_cp() {
    if [ -z "$1" ]; then
        echo "Falta el archivo a copiar."
        exit 1;
    fi
    if [ -z "$2" ]; then
        echo "Falta el destino del archivo."
        exit 1;
    fi

    container=$(docker-compose -f dev.yml ps -q $db_name);
    docker cp $1 $container:$2
}

sub_cp(){
    if [ -z "$1" ]; then
        echo "Falta el archivo a copiar."
        exit 1;
    fi
    if [ -z "$2" ]; then
        echo "Falta el destino del archivo."
        exit 1;
    fi

    container=$(docker-compose -f dev.yml ps -q $geoandino_name);
    docker cp $1 $container:$2
}


sub_sync() {

    themedir="geoandino-theme"
    path="$(dirname $PWD)/$themedir";
    if [ -d "$path" ]; then
        sub_exec rm -rf /home/geonode/geoandino/geoandino;
        sub_exec rm -rf /home/geonode/static_root;
        sub_cp "$path/." /home/geonode/geoandino
        sub_link
        sub_exec python setup.py install;
        sub_collectstatic
    else
        echo "Los archivos del tema deben estar en $path"
        exit 1;
    fi
    sub_restart;

}

subcommand=$1
case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        sub_${subcommand} $@
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' no es un subcomando conocido." >&2
            echo "       Corre '$ProgName --help' para listar los comandos." >&2
            exit 1
        fi
        ;;
esac