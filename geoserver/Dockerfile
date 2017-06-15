FROM tomcat:7.0-jre8

#Environment variables
ENV GS_VERSION 2.11.1
ENV GS_DOWNLOAD_MD5 9491b4f016e85c0cc7bf97c84ef8cfe9
ENV GS_FILE geoserver.war.zip
ENV BASE_DIR /usr/local/tomcat
ENV DATA_DIR=$BASE_DIR/webapps/geoserver/WEB-INF/data
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512M -Xss2M -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC"

WORKDIR $BASE_DIR/webapps

RUN curl -fSL -o $GS_FILE \
  https://sourceforge.net/projects/geoserver/files/GeoServer/${GS_VERSION}/geoserver-${GS_VERSION}-war.zip/download && \
  echo "$GS_DOWNLOAD_MD5 *$GS_FILE" | md5sum -c && \
  unzip $GS_FILE

EXPOSE 8080

#Set geonetwork data dir
COPY ./docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]