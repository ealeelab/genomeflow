#!/bin/bash

REFERENCE_DIR="/data/reference"
SAMPLE_ID="CGND-HRA-00099.GRCh38"
THREAD_NUM=$(nproc --all)

mkdir -p rnaseq/Picard
# remove duplicated reads
run_picard.sh AddOrReplaceReadGroups INPUT=rnaseq/STAR/${SAMPLE_ID}/Aligned.out.bam OUTPUT=rnaseq/Picard/${SAMPLE_ID}.sorted.bam SO=coordinate ID=${SAMPLE_ID} LB=unknown PL=illumina SM=${SAMPLE_ID} PU=unknown
run_picard.sh MarkDuplicates INPUT=rnaseq/Picard/${SAMPLE_ID}.sorted.bam OUTPUT=rnaseq/Picard/${SAMPLE_ID}.masked.bam M=rnaseq/Picard/${SAMPLE_ID}.matrix REMOVE_DUPLICATES=true AS=true VALIDATION_STRINGENCY=SILENT
samtools index -@ $THREAD_NUM rnaseq/Picard/${SAMPLE_ID}.masked.bam

