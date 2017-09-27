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
    error "Se encontró instalación en $INSTALL_DIR, abortando.";
    exit 1;
fi

check_dependencies() {
    info "Comproband que docker esté instalado.";
    docker ps;
    info "Comprobando que docker-compose esté instalado."
    docker-compose --version;
}

check_password() {
variable_name="$1"

if [ -z "${!variable_name}" ]; then
    info "La variable de entorno $variable_name no debe estar vacía";

    info "Por favor ingrese el valor (No se mostrará el valor):"
    read -s variable_value
    info "Por favor confirme el valor ingresado:"
    read -s variable_name_confirm

    if [ "$variable_value" != "$variable_name_confirm" ]; then
        error "Los valores no coinciden."
        exit 1;
    else
        "export" "$variable_name=$variable_value";
    fi
fi
}

check_environment_variables() {
    info "Verificando variables."
    for variable_name in POSTGRES_USER POSTGRES_DB DATASTORE_DB ALLOWED_HOST_IP ALLOWED_HOST SITEURL;
    do
      if [ -z "${!variable_name}" ]; then
        info "La variable de entorno $variable_name no debe estar vacía";
        info "Por favor ingrese el valor:"
        read $variable_name
        "export" "$variable_name=${!variable_name}";
      fi
    done
    check_password POSTGRES_PASSWORD
    info "¿Confirma los valores ingresados?"
    for variable_name in POSTGRES_USER POSTGRES_DB DATASTORE_DB ALLOWED_HOST_IP ALLOWED_HOST SITEURL;
    do
        echo "$variable_name=${!variable_name}";
    done
    if [ -z "$GEOANDINO_YES_INSTALL" ]; then
        select yn in "Si" "No"; do
            case $yn in
                Si ) break;;
                No ) error "Cancelando"; exit 1;;
            esac
        done
    fi
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
for variable_name in ALLOWED_HOST_IP ALLOWED_HOST SITEURL;
do
    echo "$variable_name=${!variable_name}" >> $env_file;
done

info "Moviendo archivos al directorio $INSTALL_DIR";

mkdir -p "$INSTALL_DIR";

mv $env_file $compose_file $management_file $INSTALL_DIR;

usr_bin_geoandino_ctl="/usr/local/bin/$management_file_name";
ln -s "$INSTALL_DIR/$management_file_name" "$usr_bin_geoandino_ctl";

info "Levantando la aplicación";
"$usr_bin_geoandino_ctl" up;
"$usr_bin_geoandino_ctl" wait;
info "Inicializacion la base de datos"
"$usr_bin_geoandino_ctl" migrate;
info "Cargando datos iniciales";
"$usr_bin_geoandino_ctl" init;
info "Reiniciando la aplicación";
"$usr_bin_geoandino_ctl" restart;

rm $download_dir -rf;

info "Instalación completa"
info "Puede controlar geoandino mediante 'geoandino-ctl'"
$INSTALL_DIR/$management_file_name --help
