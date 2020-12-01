#!/bin/bash
set -e

# remove K10plus PPPN statements on humans, property should only be used on bibliographic records

wd sparql -f table <(echo 'SELECT ?qid ?ppn { ?qid wdt:P31 wd:Q5 ; wdt:P6721 ?ppn }') | tail -n +2 | \
while read QID PPN
do
    GUID=$(wd claims "$QID" P6721 "$PPN" || true 2> /dev/null)
    if [ ! -z "$GUID" ]; then
        echo "-$QID $PPN"
        wd remove-claim "$GUID"
        sleep 10
    fi
done
