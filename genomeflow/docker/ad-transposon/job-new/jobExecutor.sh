#!/bin/bash

TOTAL_JOB=252
#END_NUM=127
END_NUM=51
START_NUM=3

for job_no in $(seq $START_NUM $END_NUM);
do
  echo "Execute job_no:"$job_no
  rm -rf job-ready.yaml
  sed -e 's/\[JOB_NUMBER\]/'${job_no}'/g' job-new.yml > job-ready.yml

  #Execute job
  kubectl apply -f ./job-ready.yml

  rm -rf job.yml-e

done