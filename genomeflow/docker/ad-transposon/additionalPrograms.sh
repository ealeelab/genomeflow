#!/bin/bash

SAMPLE_NAME=$1
REF_DIR=$2
inputDirectory=$3
outputDirectory=$4
QUEUE=$5
CORE=$6

L1EM=/app/L1EM
L1EM_REF=${REF_DIR}/hg38

#SAMPLE_NAME=$(echo $SAMPLE_FILE | awk -F '.' '{print $1}')
echo $SAMPLE_NAME

# rTEA file copy (for backup)



if [ -d "$outputDirectory/$SAMPLE_NAME" ]; then
  rm -rf "$outputDirectory/$SAMPLE_NAME"
  mkdir -p "$outputDirectory/$SAMPLE_NAME"
else
  mkdir -p "$outputDirectory/$SAMPLE_NAME"
fi

jobDirectory="$outputDirectory/$SAMPLE_NAME"

cd $jobDirectory
# FASTQ
samtools sort -@ $CORE -n $inputDirectory/$SAMPLE_NAME.bam -o $jobDirectory/$SAMPLE_NAME.sorted.bam

samtools fastq -@ $CORE $jobDirectory/$SAMPLE_NAME.sorted.bam \
    -1 $jobDirectory/$SAMPLE_NAME.R1.fastq.gz \
    -2 $jobDirectory/$SAMPLE_NAME.R2.fastq.gz \
    -0 /dev/null -s /dev/null -n

# STAR Alignment
STAR --runThreadN $CORE --genomeDir /app/rtea/hg38/additionalPrograms/GENCODE_149 \
    --winAnchorMultimapNmax 100 --outFilterMultimapNmax 100 \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate --outFileNamePrefix \
    $jobDirectory/$SAMPLE_NAME --readFilesIn \
    $jobDirectory/$SAMPLE_NAME.R1.fastq.gz $jobDirectory/$SAMPLE_NAME.R2.fastq.gz


samtools index -@ 7 $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam

# TELocal
mkdir -p $jobDirectory/TELocal/STAR
cd $jobDirectory/TELocal/STAR

TElocal --stranded reverse --sortByPos --mode multi \
-b $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam --project $SAMPLE_NAME \
--GTF ${REF_DIR}/gencode.v38.primary_assembly.annotation.gtf \
--TE ${REF_DIR}/GRCh38_GENCODE_rmsk_TE.gtf.locInd 2>&1 | tee job.log &

# TETranscript
mkdir -p $jobDirectory/TETranscript/STAR
cd $jobDirectory/TETranscript/STAR

TEcount --stranded reverse --sortByPos --format BAM \
--mode multi -b $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam \
--GTF $REF_DIR/gencode.v38.primary_assembly.annotation.gtf \
--TE $REF_DIR/GRCh38_GENCODE_rmsk_TE.gtf 2>&1 | tee job.log &


mkdir -p $jobDirectory/L1EM
#chown -R l1em:l1em $jobDirectory


. /opt/anaconda3/etc/profile.d/conda.sh
conda activate L1EM
which bwa

mkdir $jobDirectory/L1EM/STAR
cd $jobDirectory/L1EM/STAR

bash -e ${L1EM}/run_L1EM.sh \
     $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam \
     ${L1EM} \
     ${L1EM_REF}/hg38.fa 2>&1 | tee job.log &

wait

conda deactivate


# MOVE to bucket and Clean up
# (1) STAR AlignedFile
gsutil -m cp -r $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam gs://ad_transposon/${QUEUE}/${SAMPLE_NAME}/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam
# (2) TE Local
gsutil -m cp -r $jobDirectory/TELocal/STAR gs://ad_transposon/${QUEUE}/${SAMPLE_NAME}/TELocal
# (3) TE Transcript
gsutil -m cp -r $jobDirectory/TETranscript/STAR gs://ad_transposon/${QUEUE}/${SAMPLE_NAME}/TETranscript
# (4) L1EM
gsutil -m cp -r $jobDirectory/L1EM/STAR gs://ad_transposon/${QUEUE}/${SAMPLE_NAME}/L1EM
