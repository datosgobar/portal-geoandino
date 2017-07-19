FROM mdillon/postgis:9.6

ENV PGDATA=/var/lib/postgresql/data/pgdata

# Installing postgis in debian is broken. Using image with postgis already installed.
#FROM postgres:9.6.3 Do not use untill debian dependencies where fixed

#RUN apt-get update && apt-get install -y postgresql-9.6-postgis-scripts postgresql-9.6-postgis
#RUN apt-get install -y postgis && \
#      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD 000_check_datastore_db.sh 001_add_datadb.sh /docker-entrypoint-initdb.d/