#!/bin/bash

TOKEN=$(getTokenFromPassword -p $JUPYTER_TOKEN_KEY)

jupyter lab --no-browser --ip=0.0.0.0 --NotebookApp.token='$TOKEN' --NotebookApp.password='' --allow-root
