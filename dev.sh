#!/bin/bash
set -e

ProgName=$(basename $0);
geoandino_name="geonode";

sub_help(){
    echo "Uso: $ProgName <subcomando> [opciones]"
    echo "Subcomandos:"
    echo "    up                Levantar la aplicacion (Regenerar si es necesario)"
    echo "    migrate           Migrar la base de datos"
    echo "    test              Correr los tests de la aplicacion"
    echo "    down              Borrar la aplicacion y sus datos"
    echo "    cp <file> <dest>  Copiar archivo dentro del contenedor"
    echo "    console           Entrar en la consola del contenedor"
    echo ""
}
  
sub_up(){
    docker-compose -f dev.yml up --build -d;
}
  
sub_down(){
    docker-compose -f dev.yml down -v;
}

sub_migrate(){
    docker-compose -f dev.yml exec $geoandino_name python manage.py migrate;
}

sub_test() {
    docker-compose -f dev.yml exec $geoandino_name python manage.py test;
}

sub_console() {
    docker-compose -f dev.yml exec $geoandino_name bash;
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