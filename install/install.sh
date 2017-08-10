#!/usr/bin/env bash
set -e;

BRANCH="master"

STABLE_FILE_URL="https://raw.githubusercontent.com/datosgobar/portal-geoandino/$BRANCH/install/stable_version.txt"

info() {
    echo -e "\e[38;5;75m\e[1m[ INFO ]\e[0m $1";
}

success() {
    echo -e "\e[38;5;76m\e[1m[ SUCCESS ]\e[0m $1";   
}

error() {
    echo -e "\e[1m\e[31m[ ERROR ]\e[0m $1";
}

download_dir=$(mktemp -d);
installer_file="$download_dir/installer.sh";
stable_file="$download_dir/stable.txt";

info "Obteniendo version estable.";

curl "$STABLE_FILE_URL" --output "$stable_file";
stable_version=$(cat $stable_file);

info "Descargando script de instalación en $download_dir";

installer_url="https://raw.githubusercontent.com/datosgobar/portal-geoandino/$stable_version/install/installer.sh"

curl "$installer_url" --output "$installer_file";
chmod +x "$installer_file";

info "Iniciando instalacion";

"$installer_file" "$stable_version";

rm -rf "$download_dir"

success "Instalación exitosa.";
