#!/bin/bash

REFERENCE_DIR="/data/reference"
SAMPLE_ID="CGND-HRA-00099.GRCh38"
THREAD_NUM=$(nproc --all)
WORK_DIR=/data

cd $WORK_DIR

mkdir -p rnaseq/bam_ready

# remove improper-paired and multiple-hit reads
samtools view -f 2 -F 768 -h rnaseq/GATK/${SAMPLE_ID}.BQSR.bam | samtools view -Sb - > rnaseq/bam_ready/${SAMPLE_ID}.final.bam
samtools index rnaseq/bam_ready/${SAMPLE_ID}.final.bam