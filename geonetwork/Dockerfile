FROM tomcat:7.0

#Environment variables
ENV GN_VERSION 2.6.4
ENV GN_DOWNLOAD_MD5 ca37a5d6aac22c5a86aae99eb87797e3
ENV GN_FILE geonetwork.war
ENV BASE_DIR /usr/local/tomcat
ENV DATA_DIR=$BASE_DIR/webapps/geonetwork/WEB-INF/data
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512M -Xss2M -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC"

WORKDIR $BASE_DIR/webapps

# The original downlaod url is
# https://sourceforge.net/projects/geonetwork/files/GeoNetwork_opensource/v${GN_VERSION}/geonetwork.war/download
# But  sourceforge.net is down :/

RUN curl -fSL -o $GN_FILE \
  https://netix.dl.sourceforge.net/project/geonetwork/GeoNetwork_opensource/v${GN_VERSION}/geonetwork.war && \
  echo "$GN_DOWNLOAD_MD5 *$GN_FILE" | md5sum -c

RUN  mkdir -p $BASE_DIR/webapps/geonetwork && \
        unzip -e $BASE_DIR/webapps/$GN_FILE -d $BASE_DIR/webapps/geonetwork

EXPOSE 8080

#Set geonetwork data dir
COPY ./docker-entrypoint.sh /entrypoint.sh

VOLUME $DATA_DIR

ENTRYPOINT ["/entrypoint.sh"]
