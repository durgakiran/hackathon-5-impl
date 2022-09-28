#!/bin/bash

echo "lauch client server in the docker network"


# stop client container
CONTAINER_ID=`sudo docker ps | grep compose_api_1 | awk '{ print $1 }'`


if [ -n "$CONTAINER_ID" ]; then
    echo "container is running, stopping it"
    sudo docker stop $CONTAINER_ID
else
    echo "container is not running"
    CONTAINER_ID=`sudo docker ps -aq | grep compose_api_1 | awk '{ print $1 }'`
fi

echo $CONTAINER_ID

# rebuild the image (don't change tag)
sudo docker build ./express/ -t api:1.0

# bring up new container
sudo docker-compose -f ./compose/compose-client.yaml up -d


sudo docker ps | grep compose_api_1
