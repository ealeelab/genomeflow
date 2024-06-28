#!/bin/bash

#docker build -t ad-transposon-bastion:0.1 --build-arg BUILDKIT_INLINE_CACHE=1 .

VERSION="0.1"
IMAGE_NAME="genomeflow-bastion"
PROJECT_NAME="gtex-genotype"
CMD="D"

docker build -t ${IMAGE_NAME}:${VERSION} --build-arg BUILDKIT_INLINE_CACHE=1 .

#if [ $(docker images | grep $IMAGE_NAME | grep $VERSION | wc -l) == 1 ]; then
#
#  if [ $(docker images | grep "gcr.io/$PROJECT_NAME/$IMAGE_NAME" | grep $VERSION | wc -l) == 0 ]; then
#    docker tag $IMAGE_NAME:$VERSION gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION
#
#  fi
#
#
#  if [ $(gcloud container images list-tags gcr.io/$PROJECT_NAME/$IMAGE_NAME | awk 'FNR > 1 {print $2}' | grep $VERSION | wc -l) == 0 ]; then
#    gcloud docker -- push gcr.io/$PROJECT_NAME/${IMAGE_NAME}:${VERSION}
#
#
#  else
#
#    if [ $CMD == "D" ]; then
#      echo "D.E.L.E.T.E. duplicated $IMAGE_NAME:$VERSION"
#      gcloud container images delete --quiet gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION
#      gcloud docker -- push gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION
#    fi
#
#  fi
#
#fi