#!/bin/bash
set -e

#Set geoserver data dir
OPTS="$CATALINA_OPTS -Dgeoserver.dir=$DATA_DIR -Xmx1024M -Xms1024M -XX:CompileCommand=exclude,net/sf/saxon/event/ReceivingContentHandler.startEvent"

sed -i '$d' /usr/local/tomcat/bin/setclasspath.sh
echo "CATALINA_OPTS=\"$OPTS\"" >> /usr/local/tomcat/bin/setclasspath.sh
echo "fi" >> /usr/local/tomcat/bin/setclasspath.sh


"$BASE_DIR"/bin/catalina.sh run

exec "$@"