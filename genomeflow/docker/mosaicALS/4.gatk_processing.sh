#!/bin/bash

REFERENCE_DIR="/data/reference"
SAMPLE_ID="CGND-HRA-00099.GRCh38"
THREAD_NUM=$(nproc --all)

## read_process
mkdir -p rnaseq/GATK

# split'N'Trim and mapping quality reassignment
run_gatk_3.6.sh -T SplitNCigarReads -R ${REFERENCE_DIR}/Homo_sapiens_assembly38.fasta -I rnaseq/Picard/${PROJECT_NAME}.masked.bam -o rnaseq/GATK/${PROJECT_NAME}.split.bam -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS

## local_realignment
run_gatk_3.6.sh -T RealignerTargetCreator -nt ${THREAD_NUM} -R ${REFERENCE_DIR}/Homo_sapiens_assembly38.fasta -I rnaseq/GATK/${PROJECT_NAME}.split.bam -o rnaseq/GATK/${PROJECT_NAME}.intervals
run_gatk_3.6.sh -T IndelRealigner -R ${REFERENCE_DIR}/Homo_sapiens_assembly38.fasta -I rnaseq/GATK/${PROJECT_NAME}.split.bam -targetIntervals rnaseq/GATK/${PROJECT_NAME}.intervals -o rnaseq/GATK/${PROJECT_NAME}.realigned.bam


## read_recalibration
run_gatk_3.6.sh -T BaseRecalibrator -R ${REFERENCE_DIR}/Homo_sapiens_assembly38.fasta -I rnaseq/GATK/${PROJECT_NAME}.realigned.bam -knownSites ${REFERENCE_DIR}/Homo_sapiens_assembly38.dbsnp138.vcf -o rnaseq/GATK/${PROJECT_NAME}.recal_data.grp
run_gatk_3.6.sh -T PrintReads -nct ${THREAD_NUM} -R ${REFERENCE_DIR}/Homo_sapiens_assembly38.fasta -I rnaseq/GATK/${PROJECT_NAME}.realigned.bam -BQSR rnaseq/GATK/${PROJECT_NAME}.recal_data.grp -o rnaseq/GATK/${PROJECT_NAME}.BQSR.bam