# Desarrollo


Para levantar la aplicacion en modo desarrolo, basta con correr el siguiente comando:

    docker-compose -f dev.yml up -d --build

Luego de que el proceso termine, hay que inicializar la aplicacion:

     docker-compose -f dev.yml exec geonode python manage.py migrate

Para crear un nuevo usuario administrador en la aplicacion:

     docker-compose -f dev.yml exec geonode python manage.py createsuperuser