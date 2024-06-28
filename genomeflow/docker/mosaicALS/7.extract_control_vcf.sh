SP_set REFERENCE_DIR="/lab-share/Gene-Lee-e2/Public/home/jspark/mosaicALS/reference/hg38"

mkdir -p genome/HaplotypeCaller

run_gatk_3.6.sh -T SelectVariants -R ${REFERENCE_DIR}/Homo_sapiens_assembly38.fasta -V ROSMAP_WGS.tsv.gz -o genome/HaplotypeCaller/${PROJECT_NAME}.control.SNP.vcf $(awk -v name=${PROJECT_NAME} '{if($1==name){printf "-sn "$2" "}}' rosmap.id) -selectType SNP -env -ef