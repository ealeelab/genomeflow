SP_set REFERENCE_DIR="/lab-share/Gene-Lee-e2/Public/home/jspark/mosaicALS/reference/hg38"
SP_set TOOLS_DIR="/lab-share/Gene-Lee-e2/Public/home/jspark/mosaicALS/tools"

mkdir -p ${OUTPUT_DIR}/ANNOVAR

awk '{OFS="\t"; if($3==$7){alt=$9} if($3==$9){alt=$7} print $1,$2,$2,$3,alt}' ${INPUT_FILE} > ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.input
annotate_variation.pl --geneanno --dbtype refgene --buildver hg38 --outfile ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME} ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.input ${REFERENCE_DIR}/human_annovar/
annotate_variation.pl --filter --dbtype 1000g2015aug_all --buildver hg38 --outfile ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME} ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.input ${REFERENCE_DIR}/human_annovar/
annotate_variation.pl --filter --dbtype gnomad_exome --buildver hg38 --outfile ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME} ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.input ${REFERENCE_DIR}/human_annovar/
annotate_variation.pl --filter --dbtype esp6500siv2_all --buildver hg38 --outfile ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME} ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.input ${REFERENCE_DIR}/human_annovar/
annotate_variation.pl --filter --dbtype exac03 --buildver hg38 --outfile ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME} ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.input ${REFERENCE_DIR}/human_annovar/
annotate_variation.pl --filter --dbtype ljb26_all -otherinfo --buildver hg38 --outfile ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME} ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.input ${REFERENCE_DIR}/human_annovar/
annotate_variation.pl --filter --dbtype cosmic70 --buildver hg38 --outfile ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME} ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.input ${REFERENCE_DIR}/human_annovar/
rm -f ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.log

cat ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.hg38_exac03_filtered ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.hg38_esp6500si_all_filtered ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.hg38_ALL.sites.2015_08_filtered ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.hg38_gnomad_exome_filtered | sort | uniq -c | awk '{if($1>=4){print $2"\t"$3}}' > ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.tmp
myjoin -F1,2 -f3,4 <(myjoin -m -F1,2 -f1,2 ${INPUT_FILE} <(myjoin -m -F1,2 -f4,6 ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.tmp ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.exonic_variant_function | cut -f1,2) | cut -f1-24) ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.hg38_cosmic70_dropped | awk '{if($1=="="){i=2;while(i<=NF-7){printf $i"\t";i++}print $(NF-5)}if($1=="+"){i=2;while(i<=NF-1){printf $i"\t";i++}print $NF}}' > ${OUTPUT_DIR}/final.annovar_filtered.tsv
rm -f ${OUTPUT_DIR}/ANNOVAR/${PROJECT_NAME}.tmp