FROM tomcat:7.0-jre8

#Environment variables
ENV GS_VERSION 2.9.x
ENV GS_FILE geoserver.war
ENV BASE_DIR /usr/local/tomcat
ENV DATA_DIR=$BASE_DIR/webapps/geoserver/WEB-INF/data
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512M -Xss2M -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC"

WORKDIR $BASE_DIR/webapps

RUN curl -fSL -o $GS_FILE \
  http://build.geonode.org/geoserver/latest/geoserver-${GS_VERSION}.war
EXPOSE 8080

#Set geonetwork data dir
COPY ./docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
