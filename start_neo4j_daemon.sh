#!/bin/bash

#Starts Neo4J Server
/usr/bin/neo4j start
status=$?
if [ $status -ne 0]; then
	echo "Failed to start Neo4J: $status"
	exit $status
fi


while sleep 90; do
	ps aux | grep neo4j | grep -q -v grep
	PROCESS_STATUS=$?

	if [ $PROCESS_STATUS -ne 0 ]; then
		echo "Neo4J has finished"
		exit -1
	fi
done