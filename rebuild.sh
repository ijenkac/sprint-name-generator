#!/usr/bin/env bash 
container_id=$(docker ps | grep "sprint-name-generator-app:latest" | cut -d" " -f1)
[ ! -z "$container_id" ] && docker stop $container_id
docker build -t sprint-name-generator-app:latest .
docker run -d -p 80:80 sprint-name-generator-app:latest
