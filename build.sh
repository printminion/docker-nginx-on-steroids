#!/bin/bash

VERSION="1.10.0-1"

set -e

echo "> 1. Building Debian package"
echo ""
docker build -f Dockerfile-build -t donbeave/nginx-on-steroids-build .

echo ""
echo "> 2. Publishing Debian package"
echo ""
docker run -e "BINTRAY_API_KEY=$BINTRAY_API_KEY" -ti donbeave/nginx-on-steroids-build

sleep 60s
echo ""
echo ""
echo "> 3. Building Docker image"
echo ""
docker build -t donbeave/nginx-on-steroids:$VERSION .

echo ""
echo "> 4. Publishing Docker image to Docker Hub"
echo ""
docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
docker push donbeave/nginx-on-steroids:$VERSION
