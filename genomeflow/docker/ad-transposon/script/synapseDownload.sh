#!/bin/bash


cat /bucket/list_old_tagged.csv | awk -F ',' 'NR!=1 {print $4}' | shuf -n 8 | sed 's/"//g' | while read SAMPLEID
do
    echo $SAMPLEID

    synapse -u nuggiowl -p chlwowns \
	    get $SAMPLEID
done
