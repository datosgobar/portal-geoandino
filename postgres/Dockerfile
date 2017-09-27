FROM postgres:9.6.5

ENV PGDATA=/var/lib/postgresql/data/pgdata

RUN apt-get update && apt-get install -y postgresql-9.6-postgis-scripts postgresql-9.6-postgis && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD 000_check_datastore_db.sh 001_add_datadb.sh /docker-entrypoint-initdb.d/
