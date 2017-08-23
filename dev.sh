#!/bin/bash


ProgName=$(basename $0);
geoandino_name="geonode";
db_name="db";

sub_help(){
    echo "Uso: $ProgName <subcomando>"
    echo "Subcomandos:"
    echo "    Aplicacion en background:"
    echo "    up (..servicio)?      Levantar la aplicacion (Regenerar si es necesario)"
    echo "    exec [comandos]       Ejecutar un comando en la aplicacion de geoandino"
    echo "    migrate               Migrar la base de datos"
    echo "    init                  Cargar los datos iniciales de geonode"
    echo "    createadmin           Crear un usuario administrador (admin)"
    echo "    test                  Correr los tests de la aplicacion"
    echo "    restart               Reiniciar el servicor geoandino"
    echo "    stop (..servicio)?    Detener los servicios"
    echo "    down                  Borrar la aplicacion y sus datos"
    echo "    cp <file> <dest>      Copiar archivo dentro del contenedor de geoandino"
    echo "    console               Entrar en la consola del contenedor de geoandino"

    echo "    Aplicacion en consola:"
    echo "    run_with <src> <dest> Levantar la aplication con un directorio mondado."
    echo "                          Debe tener los servicios levantados (up db geoserver geonetwork)."
    echo "                          (Recuerde correr "apachectl restart" para levantar apache)."
    echo "    Extras:"
    echo "    sync                  Sincronizar el theme (../geoandino-theme) con el container"
    echo ""
}

sub_command() {
    docker-compose -f dev.yml $@;
}

sub_up(){
    sub_command up --build -d $@;
}

sub_stop(){
    sub_command stop $@;
}
  
sub_down(){
    sub_command down -v;
}

sub_restart() {
    sub_command restart $geoandino_name;
}

sub_exec() {
    sub_command exec $geoandino_name $@;
}

_get_name() {
    docker inspect --format='{{.Name}}' $(docker-compose -f dev.yml ps -q $1) | sed -e 's/^\///'
}

sub_run_with() {
    if [ -z "$1" ]; then
        echo "Falta el directorio a montar."
        exit 1;
    fi
    if [ -z "$2" ]; then
        echo "Falta el destino del directorio."
        exit 1;
    fi
    db=$(_get_name db);
    geoserver=$(_get_name geoserver);
    geonetwork=$(_get_name geonetwork);
    sub_stop $geoandino_name
    echo -e "\e[32mAlgunos comando utiles:\e[39m"
    echo -e "\e[32mIniciar la app:\e[39m apachectl restart"
    echo -e "\e[32mInstalar requerimientos de test:\e[39m pip install -r requirements/testing.txt"
    echo -e "\e[32mCorrer los tests:\e[39m scripts/run_test.sh"
    echo -e "\e[32mVer los logs:\e[39m tail -f /var/logs/apache/error.log"
    echo -e "\e[32mSi es necesario, actualizá los archivos estáticos:\e[39m"
    echo "python manage.py collectstatic --noinput"
    echo "chown -R geonode:www-data ../static_root/"
    echo "apachectl restart"
    geoandino_image=$(sub_command images -q $geoandino_name)

    network=$(python -c "import docker; client = docker.from_env(); c = client.containers.get('$db'); print(list(c.attrs['NetworkSettings']['Networks'].keys())[0])")
    docker run --rm -v "$1:$2" --network $network \
        -e POSTGRES_USER=geoandino_user -e POSTGRES_PASSWORD=geoandino_pass \
        -e DATASTORE_DB=geoandino_data -e POSTGRES_DB=geoandino_db \
        -e DEBUG=1 \
        -e ALLOWED_HOST_IP=127.0.0.1 -e PROXY_ALLOWED_HOST_IP=127.0.0.1 \
        -e ALLOWED_HOST_NAME=localhost -e PROXY_ALLOWED_HOST_NAME=localhost \
        -e SITEURL=http://localhost/ \
        --link "$db:db" --link "$geonetwork:geonetwork" \
        --link "$geoserver:geoserver" \
        -p 80:80 -it $geoandino_image /bin/bash
}

sub_db_exec() {
    sub_command exec $db_name $@;
}

sub_manage() {
    sub_exec python manage.py $@;
}

sub_createadmin() {
    sub_manage createsuperuser --username admin --email admin@admin.com;
}

sub_migrate(){
    # Recommended by https://lists.osgeo.org/pipermail/geonode-users/2016-July/002102.html
    sub_manage makemigrations;
    sub_manage migrate account --noinput;
    sub_manage migrate --noinput;
}

sub_test() {
    sub_manage test --settings=geoandino.conf.settings.testing;
}

sub_init() {
    sub_manage loaddata /home/geonode/geoandino/geoandino/fixtures/initial_data_geoandino.json
}

sub_console() {
    sub_exec bash;
}

sub_collectstatic(){
    sub_manage collectstatic --noinput
    sub_exec chown -R www-data:www-data /home/geonode/static_root/
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

sub_ux_dev() {
    sub_up
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
    docker exec -it $container apachectl restart
}

subcommand=$1
case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        sub_${subcommand} $@
        rc=$?
        if [ $rc = 127 ]; then
            echo "Error: '$subcommand' no es un subcomando conocido." >&2
            echo "       Corre '$ProgName --help' para listar los comandos." >&2
            exit 1;
        fi
        if [ $rc != 0 ]; then
            exit $rc;
        fi
esac
