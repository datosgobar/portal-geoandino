# Geoandino

Implementación de [geonode](http://geonode.org/) en Docker.

## Índice

+ [Qué contiene la aplicacion](#qué-contiene-la-aplicacion)
+ [Documentacion](#documentacion)
+ [Créditos](#créditos)
+ [Contacto](#contacto)

## Qué contiene la aplicacion

+ [Geonode 2.6.x](http://geonode.org/blog/2017/05/17/geonode-2.6-released/)
+ [Geoserver 2.9.x](http://geoserver.org/)
+ [Geonetwork](http://geonetwork-opensource.org/)
+ [PostgreSQL](https://www.postgresql.org/)
+ [Postgis](http://postgis.net/)
+ [Apache](https://httpd.apache.org/)

## Dependencias

+ DOCKER: [Guía de instalación](https://docs.docker.com/engine/installation).
+ Docker Compose: [Guía de instalación](https://docs.docker.com/compose/install/)

### ¿Qué contenedores vas a instalar?

+ Geonode:
  + Packages | Service:
    + Imagen base: ubuntu xenial 16.04
    + Apache 2 | WSGI MOD
    + Geonode 2.6.x
  + Modificaciones:
    + Cambios visuales
+ Postgresql:
  + Package | Service:
    + Imagen base: `debian:jessie`
    + PostgreSQL 9.5
  + Modificaciones:
    + Instalacion de Postgis
+ Geoserver:
  + Package | Service:
    + Imagen base: `tomcat:7.0-jre8`
    + Geoserver: 2.9.x
+ Geonetwork:
  + Package | Service:
    + Imagen base: `tomcat:7.0`
    + Geonetwork: 2.6.4

---

## Documentation

Ver la [documentación](docs/index.md)

## Créditos

Este trabajo está inspirado en el desarrollo hecho por:

+ [geonode.org](http://geonode.org/)

## Contacto

Te invitamos a [crearnos un issue](https://github.com/datosgobar/geonode/issues/new?title=Encontre%20un%20bug%20en%20nombre-del-repo) en caso de que encuentres algún bug o tengas feedback de alguna parte del proyecto.

Para todo lo demás, podés mandarnos tu comentario o consulta a [datos@modernizacion.gob.ar](mailto:datos@modernizacion.gob.ar).