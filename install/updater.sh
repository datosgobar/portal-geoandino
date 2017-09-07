#!/usr/bin/env bash
set -e;

INSTALL_DIR=/etc/geoandino
INSTALL_VERSION="$1"

info() {
    echo -e "\e[38;5;75m\e[1m[ INFO ]\e[0m $1";
}

success() {
    echo -e "\e[38;5;76m\e[1m[ SUCCESS ]\e[0m $1";   
}

error() {
    echo -e "\e[1m\e[31m[ ERROR ]\e[0m $1";
}

if [ -z "$INSTALL_VERSION" ]; then
    error "Debe especificar una versión a instalar."
    exit 1;
fi

if [ -d "$INSTALL_DIR" ]; then
    info "Se encontró instalación en $INSTALL_DIR, continuando.";
else
    error "No se encontró instalación en $INSTALL_DIR, abortando.";
    exit 1;
fi

check_dependencies() {
    info "Comproband que docker esté instalado.";
    docker ps;
    info "Comprobando que docker-compose esté instalado."
    docker-compose --version;
}


check_permissions() {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
      error "Se necesitan permisos de root (sudo)";
      exit 1;
    fi
}

check_permissions;
check_dependencies;

download_dir=$(mktemp -d);
compose_file_name="docker-compose.yml"
compose_file="$download_dir/$compose_file_name"
management_file_name="geoandino-ctl"
management_file="$download_dir/$management_file_name"
env_file="$download_dir/.env";

info "Descargando archivos necesarios";

compose_url="https://raw.githubusercontent.com/datosgobar/portal-geoandino/$INSTALL_VERSION/latest.yml"
management_url="https://raw.githubusercontent.com/datosgobar/portal-geoandino/$INSTALL_VERSION/install/geoandino-ctl"
curl "$compose_url" --output "$compose_file";
curl "$management_url" --output "$management_file";
chmod +x $management_file;

info "Deteniendo la aplicación"

geoandino-ctl stop;

info "Actualizando archivos en el directorio $INSTALL_DIR";

usr_bin_geoandino_ctl="/usr/local/bin/$management_file_name";

rm $INSTALL_DIR/$compose_file_name $INSTALL_DIR/$management_file_name $usr_bin_geoandino_ctl
mv $compose_file $management_file $INSTALL_DIR;

ln -s "$INSTALL_DIR/$management_file_name" "$usr_bin_geoandino_ctl";

info "Levantando la aplicación";
"$usr_bin_geoandino_ctl" up;
"$usr_bin_geoandino_ctl" wait;
info "Migrando la base de datos"
"$usr_bin_geoandino_ctl" migrate;
info "Reiniciando la aplicación";
"$usr_bin_geoandino_ctl" restart;
"$usr_bin_geoandino_ctl" wait;
info "Corriendo comandos post-actualización";
"$usr_bin_geoandino_ctl" post-update;

rm $download_dir -rf;

success "Actualización completa"
info "Puede controlar geoandino mediante 'geoandino-ctl'"

"$usr_bin_geoandino_ctl" --help
