#!/usr/bin/env bash

CANCER_TYPES=("COAD" "READ" "ESCA" "STAD" "LUSC" "LUAD" "HNSC" "UCEC" "OV" "CESC")
#CANCER_TYPES=("COAD" "READ" "ESCA")

for i in "${CANCER_TYPES[@]}"
do
    QUE_NAME=$i
    FILE_NAME="sampleFiles/${QUE_NAME}.txt"

    while IFS= read -r line
    do
        /usr/bin/amqp-consume --url=$BROKER_URL -q $QUE_NAME -c 1 cat && echo
    done < "$FILE_NAME"
done