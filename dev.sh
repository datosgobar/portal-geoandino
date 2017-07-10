#!/bin/bash
set -e

ProgName=$(basename $0)
  
sub_help(){
    echo "Uso: $ProgName <subcomando> [opciones]\n"
    echo "Subcomandos:"
    echo "    up        Levantar la aplicacion (Regenerar si es necesario)"
    echo "    migrate   Migrar la base de datos"
    echo "    down      Borrar la aplicacion y sus datos"
    echo ""
}
  
sub_up(){
    docker-compose -f dev.yml up --build -d;
}
  
sub_down(){
    docker-compose -f dev.yml down -v;
}

sub_migrate(){
    docker-compose -f dev.yml exec geonode python manage.py migrate;
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