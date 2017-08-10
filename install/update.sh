#!/usr/bin/env bash
set -e;

BRANCH="master"

STABLE_FILE_URL="https://raw.githubusercontent.com/datosgobar/portal-geoandino/$BRANCH/install/stable_version.txt"

info() {
    echo "[ INFO ] $1";
}

error() {
    echo -e "\e[31m[ ERROR ]\e[0m $1";
}

download_dir=$(mktemp -d);
updater_file="$download_dir/updater.sh";
stable_file="$download_dir/stable.txt";

info "Obteniendo version estable.";

curl "$STABLE_FILE_URL" --output "$stable_file";
stable_version=$(cat $stable_file);

info "Descargando script de instalación en $download_dir";

updater_url="https://raw.githubusercontent.com/datosgobar/portal-geoandino/$stable_version/install/updater.sh"

curl "$updater_url" --output "$updater_file";
chmod +x "$updater_file";

info "Iniciando actualización";

"$updater_file" "$stable_version";

rm -rf "$download_dir"

info "Actualización exitosa.";
