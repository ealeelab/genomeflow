#!/bin/bash

SAMPLEID=$1
DOWNLOAD_LOCATION=$2

mkdir -p $DOWNLOAD_LOCATION
cd $DOWNLOAD_LOCATION

echo $SAMPLEID

synapse -u nuggiowl -p chlwowns \
  get $SAMPLEID

DOWNLOAD_FILE=$(ls -alF | grep *.bam | awk '{print $9}')
mv ${DOWNLOAD_FILE} ${SAMPLEID}.bam

