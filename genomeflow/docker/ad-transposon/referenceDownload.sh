#!/bin/bash

BUCKET_LOCATION=$1
DOWNLOAD_LOCATION=$2

mkdir -p ${DOWNLOAD_LOCATION}
gsutil -m cp -r gs://${BUCKET_LOCATION} $DOWNLOAD_LOCATION

mv $DOWNLOAD_LOCATION/refs/* $DOWNLOAD_LOCATION
#ln -s /app/rtea/hg38 /app/rtea/ref

## L1EM Reference File (Reference Files)
gsutil -m rsync -r gs://ad_transposon/L1EM /app/L1EM/annotation
