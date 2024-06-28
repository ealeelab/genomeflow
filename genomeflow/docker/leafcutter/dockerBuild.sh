#!/bin/bash

IMAGE_NAME="leafcutter"
DOCKER_REPO="junseokpark/$IMAGE_NAME"
BUILD_VERSION="0.1"

docker stop $DOCKER_REPO
docker rm $DOCKER_REPO
docker rmi $DOCKER_REPO:${BUILD_VERSION}

GOOGLE_CREDENTIAL_FILE_STEA=gcp-keys/aleelab-tes-3f27476851d5.json
GOOGLE_BUCKET_STEA=aleelab-tes-development
TOKEN_KEY="aleelabLeafCutter1216"


docker build -t $DOCKER_REPO:$BUILD_VERSION \
  --build-arg BUILDKIT_INLINE_CACHE=1  \
  --build-arg GOOGLE_CREDENTIAL_FILE=$GOOGLE_CREDENTIAL_FILE \
  --build-arg GOOGLE_BUCKET=$GOOGLE_BUCKET \
  --build-arg TOKEN_KEY=$TOKEN_KEY \
  .

PROJECT_NAME="aleelab-tes"

docker tag $DOCKER_REPO:$BUILD_VERSION gcr.io/$PROJECT_NAME/$IMAGE_NAME:$BUILD_VERSION
gcloud docker -- push gcr.io/$PROJECT_NAME/${IMAGE_NAME}:${BUILD_VERSION}
