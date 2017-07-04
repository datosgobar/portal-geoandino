FROM tomcat:7.0-jre8

#Environment variables
ENV BASE_DIR=/usr/local/tomcat \
    ANSIBLE_SERVER_KEY=93C4A3FD7BB9C367 \
    JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512M -Xss2M -XX:+UseConcMarkSweepGC"

ENV GS_VERSION=2.9.x \
    GS_FILE=geoserver.war \
    DATA_DIR=$BASE_DIR/webapps/geoserver/data \
    GEOSERVER_DATA_ROOT=$BASE_DIR/webapps/geoserver/data

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list && \
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $ANSIBLE_SERVER_KEY && \
      apt-get update -y && apt-get install ansible -y
RUN mkdir /app/
ADD ./playbook.yml /app
COPY ./roles /app/roles
ADD ./group_vars /app/group_vars
RUN ansible-playbook -i "localhost," -c local /app/playbook.yml -vv && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $BASE_DIR/webapps

VOLUME $DATA_DIR

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
