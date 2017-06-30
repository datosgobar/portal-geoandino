# Producción

## Configuracion de impresión

Una configuración requerida para la que la impresión funcione correctamente es agregar tu IP al archivo `printing/config.yaml` en el servicio de `geoserver`. El mismo puede llevarse a cabo corriendo el siguiente script:

    docker-compose geoserver exec /usr/local/bin/add_printing_host.sh $IP
