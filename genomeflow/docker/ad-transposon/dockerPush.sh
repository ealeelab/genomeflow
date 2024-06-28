#!/bin/bash

#docker build -t ad-transposon-bastion:0.1 --build-arg BUILDKIT_INLINE_CACHE=1 .

VERSION="0.1"
IMAGE_NAME="ad_transposon"
PROJECT_NAME="aleelab-genomeflow"

docker tag $IMAGE_NAME:$VERSION gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION
gcloud docker -- push gcr.io/$PROJECT_NAME/${IMAGE_NAME}:${VERSION}

#gcloud container images delete --quiet gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION
#gcloud docker -- push gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION
