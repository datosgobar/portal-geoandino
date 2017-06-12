#!/bin/bash
set -e

mkdir -p "$DATA_DIR"

#Set geonetwork data dir
sed -i '$d' /usr/local/tomcat/bin/setclasspath.sh
echo "CATALINA_OPTS=\"\$CATALINA_OPTS -Dgeonetwork.dir=$DATA_DIR\"" >> /usr/local/tomcat/bin/setclasspath.sh
echo "fi" >> /usr/local/tomcat/bin/setclasspath.sh

#Overcoming manually the fact that GN is not populating completely the data custom folder
official_data_dir=$BASE_DIR/webapps/geonetwork/WEB-INF/data
if [ "$DATA_DIR" != $official_data_dir ]; then
  cp -r $official_data_dir/* "$DATA_DIR"
fi

"$BASE_DIR"/bin/catalina.sh run

exec "$@"