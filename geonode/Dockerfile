FROM ubuntu:14.04
MAINTAINER Leandro Gomez <leandro.gz73@gmail.com>

ADD ./base/playbook.yml /base/
COPY ./base/roles /base/roles
ADD ./base/group_vars /base/group_vars
RUN apt-get -y update && \
      apt-get install -y software-properties-common && \
      add-apt-repository ppa:ansible/ansible -y && \
      apt-get update -y && apt-get install ansible -y && \
      ansible-playbook -i "localhost," -c local /base/playbook.yml -vv && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./custom/playbook.yml /custom/
COPY ./custom/roles /custom/roles
ADD ./custom/group_vars /custom/group_vars
RUN ansible-playbook -i "localhost," -c local /custom/playbook.yml -vv && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/geonode/geonode
EXPOSE 80
CMD ["run_server.sh"]