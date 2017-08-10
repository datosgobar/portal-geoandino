# Producción


## Dependencias

+ DOCKER: [Guía de instalación](https://docs.docker.com/engine/installation)
+ Docker Compose (>1.13): [Guía de instalación](https://docs.docker.com/compose/install/)

## Instalación

Antes de empezar, debemos tener en nuestro ambiente las siguientes variables, y luego usarlas en el ambiente:

- `POSTGRES_USER`: El usuario de la base de datos que se creará
- `POSTGRES_PASSWORD`: La contraseña para el usuario de la base de datos
- `POSTGRES_DB`: El nombre de la base de datos a crear
- `DATASTORE_DB`: El nombre de la base de datos para guardar datos Geográficos
- `ALLOWED_HOST_IP`: La IP que nuestra aplicación usará, puede ser pública o privada. Nuestra aplicación verificará esta IP al recibir una llamada
- `ALLOWED_HOST`: El dominio (_sin puerto ni protocolo_) que nuestra aplicación usará. Nuestra aplicación verificará este dominio al recibir una llamada.
- `SITEURL`: La URL completa hacia nuestra aplicación, _debe contener el protocolo, terminar en `/` e incluir el puerto si difiere del `80`_.


Ejemplo:
```base
export POSTGRES_USER=mi_usuario
export POSTGRES_PASSWORD=xxxxx
export POSTGRES_DB=my_base_de_datos
export DATASTORE_DB=my_datastore
export ALLOWED_HOST_IP=127.0.0.1 # Si trabajamos en un entorno local!
export ALLOWED_HOST=localhost
export SITEURL=http://localhost/ # Debe incluir el protocolo (`http://`) y la barra final (`/`)
```

Para instalar la aplicación, hay que correr el siguien script:
    sudo -E bash -c "$(wget -O - https://raw.githubusercontent.com/datosgobar/portal-geoandino/master/install/install.sh)"

## Actualización

Para instalar la aplicación, hay que correr el siguien script:
    sudo bash -c "$(wget -O - https://raw.githubusercontent.com/datosgobar/portal-geoandino/master/install/update.sh)"

## Configuracion de impresión

Una configuración requerida para la que la impresión funcione correctamente es agregar tu IP al archivo `printing/config.yaml` en el servicio de `geoserver`. El mismo puede llevarse a cabo corriendo el siguiente script:

    docker-compose geoserver exec /usr/local/bin/add_printing_host.sh $IP


