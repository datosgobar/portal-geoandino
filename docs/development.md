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

**TODO:** Actualizar esta parte!

Para modificar el aspecto de la aplicacion, primero lea la [documentacion de geonode](https://geonode.readthedocs.io/en/master/tutorials/admin/customize_lookfeel/customize/theme_admin.html)

### Cambios por css

En el directorio `custom/roles/custom/files` hay un directorio `custom` que corresponde al proyecto instalado como modificacion de geonode.
El mismo contiene un archivo `.css` de ejemplo llamado [site_base.css](/geonode/custom/roles/custom/files/custom/custom/static/css/site_base.css) y una imagen para ejemplificar como proceder con las modificaciones.

Para ver como impactan las modificaciones en el proyecto, despues de modificar los archivos, se debe volver a correr el comando:

    docker-compose -f dev.yml up -d --build

Esto hara que se apliquen los cambios en el contenedor.