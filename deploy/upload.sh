#!/usr/bin/env bash

set -e;

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASS";

geoandino_image=$(docker-compose -f dev.yml images -q geonode);
geoserver_image=$(docker-compose -f dev.yml images -q geoserver);
geonetwork_image=$(docker-compose -f dev.yml images -q geonetwork);
postgresql_image=$(docker-compose -f dev.yml images -q db);

tag="$1";
echo "Deploying tag: $tag"

deploy_portal () {
    image="$1"
    image_full_name="datosgobar/$image:$tag"
    docker tag "$2" "$image_full_name"

    echo "Deploying image $image_full_name"
    docker push "$image_full_name"
}

deploy_portal portal-geoandino $geoandino_image
deploy_portal portal-geoandino-geoserver $geoserver_image
deploy_portal portal-geoandino-geonetwork $geonetwork_image
deploy_portal portal-geoandino-postgres $postgresql_image

echo "Deploy finished!"
exit 0