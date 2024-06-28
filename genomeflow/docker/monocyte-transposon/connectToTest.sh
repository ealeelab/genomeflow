#!/usr/bin/env bash

#export TARGET_POD_GROUP="ad-transposon-test"
#CONTAINER_NAME="c-ad-transposon-test"

export TARGET_POD_GROUP="monocyte-test"
CONTAINER_NAME="c-monocyte-test"

PodName=`kubectl get pod | grep $TARGET_POD_GROUP | awk '{print $1}'`

kubectl exec -it $PodName --container $CONTAINER_NAME -- /bin/bash