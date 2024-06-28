#!/bin/bash


# 1 Core / 8GB Memory

mkdir -p rnaseq/fastq
mkdir -p rnaseq/bam_raw

SAMPLE_ID="CGND-HRA-00099.GRCh38"

cp /mnt/samples/${SAMPLE_ID}.bam ./rnaseq/bam_raw/
cp /mnt/samples/${SAMPLE_ID}.bam.bai ./rnaseq/bam_raw/

run_picard.sh SortSam INPUT=rnaseq/bam_raw/${SAMPLE_ID}.bam OUTPUT=rnaseq/fastq/${SAMPLE_ID}.name_sorted.bam SORT_ORDER=queryname VALIDATION_STRINGENCY=SILENT
run_picard.sh SamToFastq INPUT=rnaseq/fastq/${SAMPLE_ID}.name_sorted.bam F=rnaseq/fastq/${SAMPLE_ID}_1.fastq F2=rnaseq/fastq/${SAMPLE_ID}_2.fastq VALIDATION_STRINGENCY=LENIENT
cat rnaseq/fastq/${SAMPLE_ID}_1.fastq | gzip > rnaseq/fastq/${SAMPLE_ID}_1.fastq.gz
cat rnaseq/fastq/${SAMPLE_ID}_2.fastq | gzip > rnaseq/fastq/${SAMPLE_ID}_2.fastq.gz
rm -f rnaseq/fastq/${SAMPLE_ID}.name_sorted.bam rnaseq/fastq/${SAMPLE_ID}_1.fastq rnaseq/fastq/${SAMPLE_ID}_2.fastq