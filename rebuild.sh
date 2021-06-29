#!/usr/bin/env bash 
docker stop $(docker ps | grep "sprint-name-generator-web:latest" | cut -d" " -f1)
docker build -t sprint-name-generator-web:latest .
docker run -d -p 80:80 sprint-name-generator-web:latest
