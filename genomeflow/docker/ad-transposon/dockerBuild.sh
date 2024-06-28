#!/bin/bash

#DOCKER_BUILDKIT=1 docker build -t leelab_dev --no-cache .
#DOCKER_BUILDKIT=1 docker build -t leelab_dev:0.4 --no-cache .
#docker build -t leelab_dev:0.7 --build-arg BUILDKIT_INLINE_CACHE=1 .
BUILD_VERSION="1.0"


GOOGLE_CREDENTIAL_FILE=aleelab-genomeflow-c89b0fb50650.json
GCP_PROJECT=aleelab-genomeflow

docker stop ad_transposon
docker rm ad_transposon
docker rmi ad_transposon:${BUILD_VERSION}

#--build-arg DOCKER_OPTS="--dns=my-private-dns-server-ip --dns=8.8.8.8" \


docker build -t ad_transposon:$BUILD_VERSION \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg GOOGLE_CREDENTIAL_FILE=$GOOGLE_CREDENTIAL_FILE \
  --build-arg GCP_PROJECT=$GCP_PROJECT \
  .

VERSION="1.0"
IMAGE_NAME="ad_transposon"
PROJECT_NAME="aleelab-genomeflow"

docker tag $IMAGE_NAME:$VERSION gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION
gcloud docker -- push gcr.io/$PROJECT_NAME/${IMAGE_NAME}:${VERSION}