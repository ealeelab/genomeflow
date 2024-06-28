#!/bin/bash

SAMPLEID=$1
DOWNLOAD_LOCATION=$2

mkdir -p $DOWNLOAD_LOCATION
cd $DOWNLOAD_LOCATION

echo $SAMPLEID
gsutil -u gtex-genotype cp -m gs://$SAMPLEID .

DOWNLOAD_FILE=$(ls -alF | grep *.bam | awk '{print $9}')
mv ${DOWNLOAD_FILE} ${SAMPLEID}.bam

