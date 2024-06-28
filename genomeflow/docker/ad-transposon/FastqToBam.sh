#!/bin/bash

FILENAME=$1
SAMPLE_NAME=$2

java -XX:ParallelGCThreads=7 -jar /app/picard.jar FastqToSam \
   F1=/app/rtea/SRR3807929/$FILENAME \
   OUTPUT=/app/rtea/SRR3807929/$SAMPLENAME.unaligned_reads.bam \
   SM=$SAMPLE_NAME
   #RG=rg0013
