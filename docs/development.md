# Desarrollo

## Levantar la aplicacion

Para levantar la aplicacion en modo desarrolo, basta con correr el siguiente comando:

    docker-compose -f dev.yml up -d --build

Luego de que el proceso termine, hay que inicializar la aplicacion:

     docker-compose -f dev.yml exec geonode python manage.py migrate

Ahora se pueden cargar los datos iniciales de la aplicacion:

     docker-compose -f dev.yml exec geonode python manage.py loaddata /home/geonode/geonode/geonode/base/fixtures

Para crear un nuevo usuario administrador en la aplicacion:

     docker-compose -f dev.yml exec geonode python manage.py createsuperuser

## Cambios en el aspecto

Para modificar el aspecto de la aplicacion, primero lea la [documentacion de geonode](https://geonode.readthedocs.io/en/master/tutorials/admin/customize_lookfeel/customize/theme_admin.html)

### Cambios directos

El contenedor que tiene los archivos de *look&feel* de la aplicación es `geonode`.
Para modificarlos se pueden seguir los siguientes pasos:

1. Levantar la aplicación: `docker-compose -f dev.yml up -d --build`
1. Entrar en el contenedor: `docker-compose -f dev.yml exec geonode /bin/bash`
1. Ir al directorio `/home/geonode/geoandino`
1. Hacer los cambios necesarios
1. Reiniciar la aplicación *desde dentro del contenedor*: `apachectrl restart`

Como tip adicional, en desarrollo, dentro del contenedor habrá un directorio `/development` donde estarán los archivos de geoandino, ese directorio puede usarse para copiar archivos desde el *host* hacia el contenedor.

### Actualización

Los archivos del tema de *geoandino* son tomados del repositorio [geoandino-theme](https://github.com/datosgobar/geoandino-theme).
Para actualizar la version, basta con ir al archivo `geonode/geoandino/roles/geoandino/tasks/main.yml` y en la tarea `git` cambiar la versión.
Por ejemplo, si la version actual es `master`, el archivo se lucirá así:

```yml
- name: Clone geoandino theme
  git:
    repo: 'https://github.com/datosgobar/geoandino-theme.git'
    dest: /home/geonode/geoandino
    version: master
```

Entones, si se quiere cambiar a la versión `0.1-release`, basta con cambiar la clave `version`:

```yml
- name: Clone geoandino theme
  git:
    repo: 'https://github.com/datosgobar/geoandino-theme.git'
    dest: /home/geonode/geoandino
    version: 0.1-release
```

### Avanzado

Para trabajar con el repositorio del tema directamente montado en el contenedor, se pueden seguir los siguientes pasos.
(NOTA: `$THEME_PATH` hace referencia al repositorio del tema en la máquina `host`, no en el conenedor)

Primero hay que levantar los servicios:

    docker build -t db postgres/
    docker build -t geoserver geoserver/
    docker build -t geonetwork geonetwork/
    docker run --name db -e POSTGRES_USER=geonode \
        -e POSTGRES_PASSWORD=geonode \
        -e DATASTORE_DB=geonode_data -d db
    docker run --name geoserver -d geoserver
    docker run --name geonetwork -d geonetwork

Luego contruir la imagen de la aplicación (Este paso puede tardar bastante):

    docker build -t geonode geonode/

Luego levantar la aplicación con los servicios y el repositorio montado.

    docker run -v $THEME_PATH:/home/geonode/geoandino \
        --link "db:db" --link "geonetwork:geonetwork" \
        --link "geoserver:geoserver" \
        -p 80:80 -it geonode /bin/bash

Luego, desde dentro del contenedor, hay que configurar y reiniciar la aplicación:

    /home/geonode/bins/link_settings.sh
    python manage.py migrate
    apachectl restart

Si se cambian los archivos estáticos, deben correrse los comandos:

    python manage.py collectstatic
    apachectl restart