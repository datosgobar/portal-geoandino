#!/usr/bin/env bash
set -e;

INSTALL_DIR=/etc/geoandino
INSTALL_VERSION="$1"

info() {
    echo "[ INFO ] $1";
}

error() {
    echo -e "\e[31m[ ERROR ]\e[0m $1";
}

if [ -z "$INSTALL_VERSION" ]; then
    error "Debe especificar una versión a instalar."
    exit 1;
fi

if [ -d "$INSTALL_DIR" ]; then
    error "Se encontró instalación en $INSTALL_DIR, abortando.";
    exit 1;
fi

check_dependencies() {
    info "Comproband que docker esté instalado.";
    docker ps;
    info "Comprobando que docker-compose esté instalado."
    docker-compose --version;
}

check_environment_variables() {
    for variable_name in POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB DATASTORE_DB;
    do
      if [ -z "${!variable_name}" ]; then
        error "La variable de entorno $variable_name no debe estar vacía";
        exit 1;
      fi
    done
}

check_dependencies;

mkdir -p "$INSTALL_DIR";

download_dir=$(mktemp -d);
compose_file="$download_dir/docker-compose.yml"
env_file="$download_dir/.env";

info "Descargando archivos necesarios";

compose_url=""

curl "$compose_url" --output "$compose_file";


