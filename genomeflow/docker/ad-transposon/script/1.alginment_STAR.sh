#!/bin/bash

inputDirectory=/data/testSamples
inputSampleFileName=01_120405
outputDirectory=/data/testResults

STAR --runThreadN 7 --genomeDir /data/refs/GENCODE_149 \
    --winAnchorMultimapNmax 100 --outFilterMultimapNmax 100 \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate --outFileNamePrefix \
    $outputDirectory/$inputSampleFileName --readFilesIn \
    $outputDirectory/$inputSampleFileName.R1.fastq.gz $outputDirectory/$inputSampleFileName.R2.fastq.gz


