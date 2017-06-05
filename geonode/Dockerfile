FROM ubuntu:14.04
MAINTAINER Leandro Gomez <leandro.gz73@gmail.com>

ADD ./playbook.yml .
COPY ./roles /roles
ADD ./group_vars /group_vars
RUN apt-get -y update && \
      apt-get install -y software-properties-common && \
      add-apt-repository ppa:ansible/ansible -y && \
      apt-get update -y && apt-get install ansible -y && \
      ansible-playbook -i "localhost," -c local playbook.yml -vv && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /home/geonode/geonode
EXPOSE 80
CMD ["run_server.sh"]