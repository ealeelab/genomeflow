#!/bin/bash

PICARD_DIR=/tools/picard-1.138
TMP_DIR=/data/temp/

CMD="java -XX:+UseSerialGC -Xmx64G -jar ${PICARD_DIR}/picard.jar $@"
echo ${CMD}
${CMD}