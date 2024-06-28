



REFERENCE_DIR="/lab-share/Gene-Lee-e2/Public/home/jspark/mosaicALS/reference/hg38"

mkdir -p rnaseq/coverageBed
coverageBed -abam rnaseq/bam_ready/${PROJECT_NAME}.final.bam -b ${REFERENCE_DIR}/human_gene_gencode19.hg38.exon.bed -hist | awk '$1=="all"' > rnaseq/coverageBed/${PROJECT_NAME}.tsv