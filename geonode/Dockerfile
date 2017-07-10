FROM ubuntu:14.04
MAINTAINER Leandro Gomez <lgomez@devartis.com>

ENV MEDIA_DIR=/home/geonode/uploaded/ \
      CONFIG_DIR=/home/geonode/conf

RUN apt-get -y update && \
      apt-get install -y software-properties-common && \
      add-apt-repository ppa:ansible/ansible -y

COPY ./playbook.yml /geoandino/
COPY ./roles /geoandino/roles
COPY ./group_vars /geoandino/group_vars

RUN apt-get update -y && apt-get install ansible -y && \
      ansible-playbook -i "localhost," -c local /geoandino/playbook.yml -vv && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/geonode/geoandino

VOLUME $MEDIA_DIR $CONFIG_DIR

EXPOSE 80
CMD ["run_server.sh"]