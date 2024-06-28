SP_set REFERENCE_DIR="/lab-share/Gene-Lee-e2/Public/home/jspark/mosaicALS/reference/hg38"
SP_set MOSAICHUNTER_DIR="/lab-share/Gene-Lee-e2/Public/home/jspark/mosaicALS/tools/MosaicHunter"
SP_set ERROR_PRONE_BED="/lab-share/Gene-Lee-e2/Public/home/jspark/mosaicALS/reference/hg38/error_prone.bed"
SP_set SEX="F"
SP_set START_CHR=1
SP_set END_CHR=22

mkdir -p rnaseq/MosaicHunter
mkdir -p rnaseq/MosaicHunter/${PROJECT_NAME}

SP_for_parallel _num={${START_CHR}..${END_CHR}} X Y
{
        java -Xmx32G -jar ${MOSAICHUNTER_DIR}/build/mosaichunter.jar -C ${MOSAICHUNTER_CONFIG} -P input_file=rnaseq/bam_ready/${PROJECT_NAME}.final.bam -P mosaic_filter.sex=${SEX} -P output_dir=${OUTPUT_DIR}/chr${_num} -P common_site_filter.bed_file=${ERROR_PRONE_BED} -P valid_references="chr${_num}"
        rm -f ${OUTPUT_DIR}/${_num}/misaligned_reads_filter.psl
}
for i in {${START_CHR}..${END_CHR}} X Y; do cat ${OUTPUT_DIR}/chr$i/final.passed.tsv; done > ${OUTPUT_DIR}/final.passed.tsv


cat rnaseq/MosaicHunter/${PROJECT_NAME}/final.passed.tsv | awk '$3==$7||$3==$9' | awk '$11~"N/A"&&$11~"1.0"' > rnaseq/MosaicHunter/${PROJECT_NAME}/final.clean.tsv