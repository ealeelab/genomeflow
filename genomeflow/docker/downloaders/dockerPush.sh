#!/bin/bash

IMAGE_NAME="downloader"
VERSION="synapse"
PROJECT_NAME="aleelab-genomeflow"

docker tag $IMAGE_NAME:$VERSION gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION

gcloud docker -- push gcr.io/$PROJECT_NAME/$IMAGE_NAME:$VERSION