FROM ubuntu:16.04

MAINTAINER Jason Jimenez Cruz

# Installing base software
RUN apt-get update && apt-get install git wget nano apache2 -y

# Downloading Neo4J 
RUN wget https://neo4j.com/artifact.php?name=neo4j-community-3.5.0-unix.tar.gz && tar -xf artifact.php?name=neo4j-community-3.5.0-unix.tar.gz

# Adding the APOC plugin
RUN cd /neo4j-community-3.5.0/plugins && wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.5.0.1/apoc-3.5.0.1-all.jar 

# Adding the NEO4J Graph Algorithims
RUN cd /neo4j-community-3.5.0/plugins && wget https://github.com/neo4j-contrib/neo4j-graph-algorithms/releases/download/3.5.0.1/graph-algorithms-algo-3.5.0.1.jar 

# Adding config lines for exposing neo4j ports outside the server and for enabling the plugins after starting NEO4J
RUN echo "dbms.connector.bolt.listen_address=0.0.0.0:7687" >> /neo4j-community-3.5.0/conf/neo4j.conf \
 && echo "dbms.connector.http.listen_address=0.0.0.0:7474" >> /neo4j-community-3.5.0/conf/neo4j.conf \
 && echo "dbms.security.procedures.whitelist=apoc.coll.*,apoc.load.*" >> /neo4j-community-3.5.0/conf/neo4j.conf 

# Changing the volume permissions for persistent storage of the database
RUN mkdir -p /neo4j-community-3.5.0/data/databases/graph.db && \
    chown neo4j:adm /neo4j-community-3.5.0/data/databases/graph.db && \
    chmod -R 777 /neo4j-community-3.5.0/data/databases

# Download scripts from repo
RUN git clone https://github.com/jasonjimnz/neo4j-community-docker.git start-scripts

# Apache config (For future versions of importer/exporter)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
EXPOSE 7474
EXPOSE 7687

CMD ./start-scripts/start_neo4j_daemon_350.sh