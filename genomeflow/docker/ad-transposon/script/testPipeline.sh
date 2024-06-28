#!/bin/bash


#ls -alF /data/testSamples | grep -v ".sh" | grep -v "01_120405.bam" | awk 'NR>3 {print $9}' | while read SAMPLE_FILE
inputDirectory=/data/testSamples
outputDirectory=/data/testResults
REF_DIR=/data/refs

L1EM=/home/l1em/L1EM
L1EM_REF=/data/L1EM_temp

ls -alF  $inputDirectory | grep .bam | awk '{print $9}' | while read SAMPLE_FILE
do
    SAMPLE_NAME=$(echo $SAMPLE_FILE | awk -F '.' '{print $1}')
    echo $SAMPLE_NAME



    if [ -d "$outputDirectory/$SAMPLE_NAME" ]; then
	rm -rf "$outputDirectory/$SAMPLE_NAME"
        mkdir "$outputDirectory/$SAMPLE_NAME"
    else 
        mkdir "$outputDirectory/$SAMPLE_NAME"
    fi

    jobDirectory="$outputDirectory/$SAMPLE_NAME"

    cd $jobDirectory
    # FASTQ
    samtools sort -@ 7 -n $inputDirectory/$SAMPLE_NAME.bam -o $jobDirectory/$SAMPLE_NAME.sorted.bam

    samtools fastq -@ 7 $jobDirectory/$SAMPLE_NAME.sorted.bam \
        -1 $jobDirectory/$SAMPLE_NAME.R1.fastq.gz \
        -2 $jobDirectory/$SAMPLE_NAME.R2.fastq.gz \
        -0 /dev/null -s /dev/null -n

    # STAR Alignment
    STAR --runThreadN 7 --genomeDir /data/refs/GENCODE_149 \
        --winAnchorMultimapNmax 100 --outFilterMultimapNmax 100 \
        --readFilesCommand zcat \
        --outSAMtype BAM SortedByCoordinate --outFileNamePrefix \
        $jobDirectory/$SAMPLE_NAME --readFilesIn \
        $jobDirectory/$SAMPLE_NAME.R1.fastq.gz $jobDirectory/$SAMPLE_NAME.R2.fastq.gz
    
    
    samtools index -@ 7 $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam 

    # HISAT Alignment
    /data/1.alignment_HISAT.sh $jobDirectory/$SAMPLE_NAME.R1.fastq.gz $jobDirectory/$SAMPLE_NAME.R2.fastq.gz $jobDirectory/$SAMPLE_NAME

    # TELocal
    mkdir -p $jobDirectory/TELocal/HISAT2
    cd $jobDirectory/TELocal/HISAT2

    TElocal --stranded reverse --sortByPos --mode multi \
	-b $jobDirectory/${SAMPLE_NAME}.hisat2.bam --project $SAMPLE_NAME \
	--GTF ${REF_DIR}/gencode.v38.primary_assembly.annotation.gtf \
	--TE ${REF_DIR}/GRCh38_GENCODE_rmsk_TE.gtf.locInd 2>&1 | tee job.log

    mkdir $jobDirectory/TELocal/STAR
    cd $jobDirectory/TELocal/STAR

    TElocal --stranded reverse --sortByPos --mode multi \
	-b $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam --project $SAMPLE_NAME \
	--GTF ${REF_DIR}/gencode.v38.primary_assembly.annotation.gtf \
	--TE ${REF_DIR}/GRCh38_GENCODE_rmsk_TE.gtf.locInd 2>&1 | tee job.log

    # TETranscript
    mkdir -p $jobDirectory/TETranscript/HISAT2
    cd $jobDirectory/TETranscript/HISAT2

    TEcount --stranded reverse --sortByPos --format BAM \
	--mode multi -b $jobDirectory/${SAMPLE_NAME}.hisat2.bam \
	--GTF $REF_DIR/gencode.v38.primary_assembly.annotation.gtf \
	--TE $REF_DIR/GRCh38_GENCODE_rmsk_TE.gtf 2>&1 | tee job.log

    mkdir $jobDirectory/TETranscript/STAR
    cd $jobDirectory/TETranscript/STAR

    TEcount --stranded reverse --sortByPos --format BAM \
	--mode multi -b $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam \
	--GTF $REF_DIR/gencode.v38.primary_assembly.annotation.gtf \
	--TE $REF_DIR/GRCh38_GENCODE_rmsk_TE.gtf 2>&1 | tee job.log


    mkdir $jobDirectory/L1EM
    chown -R l1em:l1em $jobDirectory

    # L1EM
    su l1em << BASH
      /bin/bash
      . /home/l1em/miniconda3/etc/profile.d/conda.sh
      conda activate L1EM
      which bwa

      mkdir $jobDirectory/L1EM/HISAT2
      cd $jobDirectory/L1EM/HISAT2

      bash -e ${L1EM}/run_L1EM.sh \
	   $jobDirectory/${SAMPLE_NAME}.hisat2.bam \
	   ${L1EM} \
	   ${L1EM_REF}/hg38.fa 2>&1 | tee job.log

      mkdir $jobDirectory/L1EM/STAR
      cd $jobDirectory/L1EM/STAR

      bash -e ${L1EM}/run_L1EM.sh \
           $jobDirectory/${SAMPLE_NAME}Aligned.sortedByCoord.out.bam \
	   ${L1EM} \
	   ${L1EM_REF}/hg38.fa 2>&1 | tee job.log

BASH


    # MOVE to bucket and Clean up
    gsutil -m cp -r $jobDirectory gs://ad_transposon/testResults
    rm -rf $jobDirectory

done
