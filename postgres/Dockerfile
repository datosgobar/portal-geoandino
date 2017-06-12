FROM postgres:9.5

RUN apt-get update && apt-get install -y postgis postgresql-9.5-postgis-scripts && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD 000_check_datastore_db.sh 001_add_datadb.sh /docker-entrypoint-initdb.d/