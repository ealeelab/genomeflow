#!/bin/bash

inputDirectory=/data/testSamples
inputSampleFileName=01_120405
outputDirectory=/data/testResults

samtools sort -@ 7 -n $inputDirectory/$inputSampleFileName.bam -o $outputDirectory/$inputSampleFileName.sorted.bam

samtools fastq -@ 7 $outputDirectory/$inputSampleFileName.sorted.bam \
    -1 $outputDirectory/$inputSampleFileName.R1.fastq.gz \
    -2 $outputDirectory/$inputSampleFileName.R2.fastq.gz \
    -0 /dev/null -s /dev/null -n
