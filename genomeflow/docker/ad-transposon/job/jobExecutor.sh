#!/bin/bash

TOTAL_JOB=636
END_NUM=636
START_NUM=586

for job_no in $(seq $START_NUM $END_NUM);
do
  echo "Execute job_no:"$job_no
  rm -rf job-ready.yaml
  sed -e 's/\[JOB_NUMBER\]/'${job_no}'/g' job.yml > job-ready.yml

  #Execute job
  kubectl apply -f ./job-ready.yml

  rm -rf job.yml-e

done