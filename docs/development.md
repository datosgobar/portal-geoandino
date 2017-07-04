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