#!/bin/bash

mkdir /data

inputDirectory=/data/testSamples
outputDirectory=/data/testResults
REF_DIR=/data/refs

L1EM=/root/L1EM
L1EM_REF=/data/refs/hg38/L1EM_refs

REF_DOWNLOAD_BUCKET=""

# Get queue


# Start to download from queue
SAMPLEID=$1
echo $SAMPLEID

# File Download
synapse -u nuggiowl -p chlwowns \
  get $SAMPLEID

DOWNLOAD_FILE=$(ls -alF | grep *.bam | awk '{print $9}')
mv ${DOWNLOAD_FILE} ${SAMPLEID}.bam

# rTEA Running (Generate hisat2.bam)



# HISAT File Transfer for Backup



# rTEA execution


