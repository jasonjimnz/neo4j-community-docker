FROM ubuntu:16.04

MAINTAINER Jason Jimenez Cruz

# Installing base software
RUN apt-get update && apt-get install git wget nano -y && \
    wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && \
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && \
    apt-get update && apt-get install -y neo4j apache2

# Adding config lines for exposing neo4j ports outside the server
RUN echo "dbms.connector.bolt.listen_address=0.0.0.0:7687" >> /etc/neo4j/neo4j.conf \
 && echo "dbms.connector.http.listen_address=0.0.0.0:7474" >> /etc/neo4j/neo4j.conf

# Changing the volume permissions for persistent storage of the database
RUN mkdir -p /var/lib/neo4j/data/databases/graph.db && \
    chown neo4j:adm /var/lib/neo4j/data/databases/graph.db && \
    mkdir -p /var/run/neo4j && /usr/bin/neo4j start

# Download scripts from repo
RUN git clone https://github.com/jasonjimnz/neo4j-community-docker.git start-scripts

# Apache config (For future versions of importer/exporter)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
EXPOSE 7474
EXPOSE 7687

CMD ./start-scripts/start_neo4j_daemon.sh