FROM tomcat:7.0-jre8

#Environment variables
ENV GS_VERSION=2.9.x \
    GS_FILE=geoserver.war \
    BASE_DIR=/usr/local/tomcat \
    DATA_DIR=$BASE_DIR/webapps/geoserver/data \
    JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512M -Xss2M -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC" \
    ANSIBLE_SERVER_KEY=93C4A3FD7BB9C367

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
