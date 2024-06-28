#!/bin/bash

SYNAPSE_ID="nuggiowl"
SYNAPSE_PASSWORD="chlwowns"

docker build -t downloader:synapse --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg SYNAPSE_ID=$SYNAPSE_ID \
  --build-arg SYNAPSE_PASSWORD=$SYNAPSE_PASSWORD \
  .