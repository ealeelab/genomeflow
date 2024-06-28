#!/bin/bash

#DOCKER_BUILDKIT=1 docker build -t leelab_dev --no-cache .
#DOCKER_BUILDKIT=1 docker build -t leelab_dev:0.4 --no-cache .
#docker build -t leelab_dev:0.7 --build-arg BUILDKIT_INLINE_CACHE=1 .
BUILD_VERSION="2.2.2"


GCP_PROJECT="aleelab-ten"

docker stop rtea-tcga
docker rm rtea-tcga
docker rmi rtea-tcga:${BUILD_VERSION}

#--build-arg DOCKER_OPTS="--dns=my-private-dns-server-ip --dns=8.8.8.8" \


docker build -t rtea-tcga:$BUILD_VERSION \
  --build-arg BUILDKIT_INLINE_CACHE=1   .

VERSION="2.2.2"
IMAGE_NAME="rtea-tcga"
PROJECT_NAME="aleelab-ten"

docker tag $IMAGE_NAME:$VERSION gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION
gcloud docker -- push gcr.io/$PROJECT_NAME/${IMAGE_NAME}:${VERSION}