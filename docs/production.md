# Producción


### Dependencias

+ DOCKER: [Guía de instalación](https://docs.docker.com/engine/installation)
+ Docker Compose (>1.13): [Guía de instalación](https://docs.docker.com/compose/install/)

## Instalación

Antes de empezar, debemos tener en nuestro ambiente las siguientes variables:

```base
export POSTGRES_USER=<Usuario para la base de datos>
export POSTGRES_PASSWORD=<Password para el usuario>
export POSTGRES_DB=<Nombre de la base de datos>
export DATASTORE_DB=<Nombre de la base de datos datastore>
export ALLOWED_HOST_IP=<IP del servidor>
export ALLOWED_HOST=<dominio de la aplicacion>
export SITEURL=<dominio incluyendo http://>

Para instalar la aplicación, hay que correr el siguien script:
    wget -O - wget https://raw.githubusercontent.com/datosgobar/portal-geoandino/master/install/install.sh | sudo -E bash

## Configuracion de impresión

Una configuración requerida para la que la impresión funcione correctamente es agregar tu IP al archivo `printing/config.yaml` en el servicio de `geoserver`. El mismo puede llevarse a cabo corriendo el siguiente script:

    docker-compose geoserver exec /usr/local/bin/add_printing_host.sh $IP
