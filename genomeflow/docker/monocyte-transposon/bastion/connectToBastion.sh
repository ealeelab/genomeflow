#!/usr/bin/env bash

export TARGET_POD_GROUP="monocyte-transposon-bastion"
CONTAINER_NAME="c-monocyte-transposon-bastion"

PodName=`kubectl get pod | grep $TARGET_POD_GROUP | awk '{print $1}'`

kubectl exec -it $PodName --container $CONTAINER_NAME -- /bin/bash