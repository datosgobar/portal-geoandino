#!/usr/bin/env bash

set -ev

container_image=$(docker-compose -f dev.yml images -q geonode)

tag="$1"

image_full_name="datosgobar/portal-geoandino:$tag"
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASS";
docker tag "$container_image" "$image_full_name"
echo "Deploying image $image_full_name"
docker push "$image_full_name"
echo "Deploy finished!"
exit 0