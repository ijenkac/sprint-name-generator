#!/usr/bin/env bash
# set -x
ACTIVE_ENVIRONMENT="blue-environment"
NEW_ENVIRONMENT="green-environment"

if docker-compose exec -T router grep -q 'green-environment;' /etc/nginx/conf.d/router.conf
then
    ACTIVE_ENVIRONMENT="green-environment"
    NEW_ENVIRONMENT="blue-environment"
fi

echo "Removing old \"$NEW_ENVIRONMENT\" container"
docker-compose rm -f -s -v $NEW_ENVIRONMENT

echo "Starting new \"$NEW_ENVIRONMENT\" container"
docker-compose up --build -d $NEW_ENVIRONMENT 
dcup_result=$?
if [ $dcup_result -eq 0 ]; then
    echo "New \"$NEW_ENVIRONMENT\" successfully created"
else
    echo "Docker compose failed with exit code: $dcup_result"
    echo "Exiting..."
    exit 1
fi

sleep 25

echo "Checking health of \"$NEW_ENVIRONMENT\" container"
docker-compose ps | grep -p $NEW_ENVIRONMENT | grep -q "healthy"
health_check=$?
if [ $health_check -eq 0 ]; then
    echo "New \"$NEW_ENVIRONMENT\" container has passed health check"
else
    echo "\"$NEW_ENVIRONMENT\" container's health check failed"
    echo "Exiting..."
    exit 1
fi

echo "Updating router settings to use \"$NEW_ENVIRONMENT\""
eval 'docker-compose exec -T router sed -i "s|proxy_pass http://.*;|proxy_pass http://$NEW_ENVIRONMENT;|g" /etc/nginx/conf.d/router.conf'


echo "Check router config"
docker-compose exec -T router nginx -g 'daemon off; master_process on;' -t
router_config=$?
if [ $router_config -eq 0 ]; then
    echo "New router config is valid"
else
    echo "New router config is not valid"
    eval 'docker-compose exec -T router sed -i "s|proxy_pass http://.*;|proxy_pass http://$ACTIVE_ENVIRONMENT;|g" /etc/nginx/conf.d/router.conf'
    echo "Rollback & Exiting..."
    exit 1
fi

echo "Reload router config"
docker-compose exec -T router nginx -g 'daemon off; master_process on;' -s reload
router_config=$?
if [ $router_config -eq 0 ]; then
    echo "Router config reloaded"
else
    echo "Router config reload has failed"
    eval 'docker-compose exec -T router sed -i "s|proxy_pass http://.*;|proxy_pass http://$ACTIVE_ENVIRONMENT;|g" /etc/nginx/conf.d/router.conf'    
    echo "Rollback & Exiting..."
    exit 1
fi

sleep 25

echo "Checking service after new deployment"
docker-compose ps | grep -p router | grep -q "healthy"
service_status=$?
if [ $service_status -eq 0 ]; then
    app_version=$(git rev-parse --short HEAD)
    echo "New deployment passed check. You should see VERSION:\"$app_version\" at the bottom of the page. Bye"
else
    echo "New deployment failed check"
    eval 'docker-compose exec -T router sed -i "s|proxy_pass http://.*;|proxy_pass http://$ACTIVE_ENVIRONMENT;|g" /etc/nginx/conf.d/router.conf'
    echo "Rollback & Exiting..."
    exit 1
fi