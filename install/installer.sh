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
    info "Verificando variables de la base de datos."
    for variable_name in POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB DATASTORE_DB;
    do
      if [ -z "${!variable_name}" ]; then
        error "La variable de entorno $variable_name no debe estar vacía";
        exit 1;
      fi
    done
    info "Verificando variables de la aplicación";
    for variable_name in ALLOWED_HOST_IP ALLOWED_HOST SITEURL;
    do
      if [ -z "${!variable_name}" ]; then
        error "La variable de entorno $variable_name no debe estar vacía";
        exit 1;
      fi
    done
}

check_permissions() {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
      error "Se necesitan permisos de root (sudo)";
      exit 1;
    fi
}
check_permissions;
check_environment_variables;
check_dependencies;

mkdir -p "$INSTALL_DIR";

download_dir=$(mktemp -d);
compose_file="$download_dir/docker-compose.yml"
management_file_name="geoandino-ctl"
management_file="$download_dir/$management_file_name"
env_file="$download_dir/.env";

info "Descargando archivos necesarios";

compose_url="https://raw.githubusercontent.com/datosgobar/portal-geoandino/$INSTALL_VERSION/latest.yml"
management_url="https://raw.githubusercontent.com/datosgobar/portal-geoandino/$INSTALL_VERSION/install/geoandino-ctl"
curl "$compose_url" --output "$compose_file";
curl "$management_url" --output "$management_file";
chmod +x $management_file;

info "Generando archivo de configuración";

touch $env_file;

for variable_name in POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB DATASTORE_DB;
do
    echo "$variable_name=${!variable_name}" >> $env_file;
done
for variable_name in ALLOWED_HOST_IP PROXY_ALLOWED_HOST_IP ALLOWED_HOST_NAME PROXY_ALLOWED_HOST_NAME SITEURL;
do
    echo "$variable_name=${!variable_name}" >> $env_file;
done

info "Moviendo archivos a directorio $INSTALL_DIR";

mv $env_file $INSTALL_DIR;
mv $compose_file $INSTALL_DIR;
mv $management_file "$INSTALL_DIR/$management_file_name";

usr_bin_geoandino_ctl="/usr/local/bin/$management_file_name";
ln -s "$INSTALL_DIR/$management_file_name" "$usr_bin_geoandino_ctl";

"$usr_bin_geoandino_ctl" up
"$usr_bin_geoandino_ctl" wait
"$usr_bin_geoandino_ctl" migrate
"$usr_bin_geoandino_ctl" init
"$usr_bin_geoandino_ctl" restart

rm $download_dir -rf;

info "Instalación completa"
