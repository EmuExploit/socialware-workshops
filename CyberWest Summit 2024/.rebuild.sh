#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "sudo plz" 
    exit 1
fi

if [ "$(docker ps -q)" ]; then
    docker-compose down
    docker-compose up -d --build
else
    docker-compose up -d --build
fi
