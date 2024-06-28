#!/bin/bash

# Reference file copy
#gsutil -m cp -r gs://reference_s1d5x1_genomeflow /data
cd /data
#mv reference_s1d5x1_genomeflow reference

PATH=$PATH:/tools

REFERENCE_DIR="/data/reference"
SAMPLE_ID="CGND-HRA-00099.GRCh38"
THREAD_NUM=$(nproc --all)

mkdir -p rnaseq/STAR

mkdir -p rnaseq/STAR/${SAMPLE_ID}

STAR --runThreadN ${THREAD_NUM} \
  --twopassMode Basic --outSAMattributes All --outSAMtype BAM Unsorted \
  --readFilesCommand zcat --genomeDir ${REFERENCE_DIR}/human_hg38/human_hg38_STAR_index10_gencode39 \
  --readFilesIn rnaseq/fastq/${SAMPLE_ID}_1.fastq.gz rnaseq/fastq/${SAMPLE_ID}_2.fastq.gz \
  --outFileNamePrefix rnaseq/STAR/${SAMPLE_ID}/