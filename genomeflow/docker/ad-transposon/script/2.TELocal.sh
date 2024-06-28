#!/bin/bash

INPUT_SAMPLE=/data/testResults/01_120405/01_120405_HISAT.hisat2.bam
REF_DIR=/data/refs


TElocal --stranded reverse --sortByPos --mode multi \
	-b $INPUT_SAMPLE --project 01_120405 \
	--GTF ${REF_DIR}/gencode.v38.primary_assembly.annotation.gtf \
	--TE ${REF_DIR}/GRCh38_GENCODE_rmsk_TE.gtf.locInd
