# Desarrollo

## Levantar la aplicación

Para levantar la aplicación en modo desarrollo, basta con correr el siguiente comando:

    docker-compose -f dev.yml up -d --build

Luego de que el proceso termine, hay que inicializar la aplicación:

     docker-compose -f dev.yml exec geonode python manage.py migrate

Ahora se pueden cargar los datos iniciales de la aplicación:

     docker-compose -f dev.yml exec geonode python manage.py loaddata /home/geonode/geonode/geonode/base/fixtures

Para crear un nuevo usuario administrador en la aplicación:

     docker-compose -f dev.yml exec geonode python manage.py createsuperuser

## Cambios en el aspecto

Para modificar el aspecto de la aplicación, primero lea la [documentación de geonode](https://geonode.readthedocs.io/en/master/tutorials/admin/customize_lookfeel/customize/theme_admin.html)

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
Para actualizar la versión, basta con ir al archivo `geonode/geoandino/roles/geoandino/tasks/main.yml` y en la tarea `git` cambiar la versión.
Por ejemplo, si la version actual es `master`, el archivo lucirá así:

```yml
- name: Clone geoandino theme
  git:
    repo: 'https://github.com/datosgobar/geoandino-theme.git'
    dest: /home/geonode/geoandino
    version: master
```

Entonces, si se quiere cambiar a la versión `0.1-release`, basta con cambiar la clave `version`:

```yml
- name: Clone geoandino theme
  git:
    repo: 'https://github.com/datosgobar/geoandino-theme.git'
    dest: /home/geonode/geoandino
    version: 0.1-release
```

### Avanzado

Para trabajar con el repositorio del tema directamente montado en el contenedor, se pueden seguir los siguientes pasos.
(NOTA: `$THEME_PATH` hace referencia al repositorio del tema en la máquina `host`, no en el contenedor)

El primer paso a realizar es levantar la aplicación siguendo los pasos indicados en la sección [Levantar la aplicación](#levantar-la-aplicaci%C3%B3n).

Una vez que ese proceso finalizó, tendremos en el _host_ creadas las imágenes y contenedores necesarios para poder modificar el contenedor que contiene la aplicación web Geoandino y montar un directorio local del host donde se podrán realizar las modificaciones.

El segundo paso es instalar una librería de Python llamada `docker`, que es utilizada por el paso siguiente para modificar en _runtime_ el contenedor de Geoandino. Esta librería puede ser instalada globalmente en el sistema _host_ o en un _virtualenv_:

    pip install docker

Finalmente se modifica el contenedor y se accede al mismo, montando el directorio de trabajo que contiene el código del _theme_ visual de Geoandino:

    ./dev.sh run_with /path/al/directorio/local/geoandino-theme/ /home/geonode/geoandino

El segundo parámetro es el path al directorio del contenedor donde se montará el directorio de trabajo local, y debe coincidir con el directorio donde está instalado el theme visual de Geoandino. Si se siguieron los pasos definidos en [Levantar la aplicación](#levantar-la-aplicaci%C3%B3n) para crear los contenedores, el mismo es `/home/geonode/geoandino`.

El comando anterior nos dejará dentro del contenedor, con el directorio de trabajo montado en `/home/geonode/geoandino`. Al ingresar se imprimirá por consola algunos comandos útiles que el desarrollador puede usar para realizar distintas acciones para controlar el ambiente durante el desarrollo de las modificaciones del _theme_ visual:

    Algunos comando utiles:
    Iniciar la app: apachectl restart
    Instalar requerimientos de test: pip install -r requirements/testing.txt
    Correr los tests: scripts/run_test.sh
    Ver los logs: tail -f /var/logs/apache/error.log
    Si es necesario, actualizá los archivos estáticos:
    python manage.py collectstatic --noinput
    chown -R geonode:www-data ../static_root/
    apachectl restart

Por ejemplo, si se desea modificar las hojas de estilo del tema visual y modificar templates HTML, será necesario correr los comandos `collectstatic` y `chown`.

Para salir del contenedor basta con tipear `exit` en la consola, pudiendo volver a ingresar utilizando el mismo comando `./dev.sh run_with` usado anteriormente para ingresar.
