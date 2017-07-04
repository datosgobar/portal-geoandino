FROM ubuntu:14.04
MAINTAINER Leandro Gomez <leandro.gz73@gmail.com>

ENV MEDIA_DIR=/home/geonode/static_root/ \
      STATIC_DIR=/home/geonode/uploaded/ \
      CONFIG_DIR=/home/geonode/conf

ADD ./base/playbook.yml /base/
COPY ./base/roles /base/roles
ADD ./base/group_vars /base/group_vars
RUN apt-get -y update && \
      apt-get install -y software-properties-common && \
      add-apt-repository ppa:ansible/ansible -y && \
      apt-get update -y && apt-get install ansible -y && \
      ansible-playbook -i "localhost," -c local /base/playbook.yml -vv && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./geoandino/playbook.yml /geoandino/
COPY ./geoandino/roles /geoandino/roles
ADD ./geoandino/group_vars /geoandino/group_vars
RUN ansible-playbook -i "localhost," -c local /geoandino/playbook.yml -vv && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/geonode/geoandino

VOLUME $MEDIA_DIR $STATIC_DIR $CONFIG_DIR

EXPOSE 80
CMD ["run_server.sh"]