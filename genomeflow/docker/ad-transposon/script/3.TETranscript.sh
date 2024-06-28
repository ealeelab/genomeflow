#!/bin/bash

RESULT_DIR=/data/testResults/TETranscript
INPUT_SAMPLE=/data/testResults/01_120405/01_120405_HISAT.hisat2.bam
REF_DIR=/data/refs

cd $RESULT_DIR

TEcount --stranded reverse --sortByPos --format BAM \
	--mode multi -b $INPUT_SAMPLE \
	--GTF $REF_DIR/gencode.v38.primary_assembly.annotation.gtf \
	--TE $REF_DIR/GRCh38_GENCODE_rmsk_TE.gtf

