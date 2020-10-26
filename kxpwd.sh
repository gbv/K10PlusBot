#!/bin/bash
set -e

LIMIT=10

# search for items with ISBN10 and no K10Plus PPN
tee query.rql <<'SPARQL'
SELECT ?qid ?isbn { 
  ?qid wdt:P957 ?isbn
  FILTER NOT EXISTS { ?qid wdt:P6721 ?ppn }
} LIMIT 10
SPARQL

wd sparql query.rql | jq -r '.[]|[.qid,.isbn]|@tsv' | \
while IFS=$'\t' read qid isbn
do
  echo -e "ISBN\t$isbn"
  if [ ! -z "$isbn" ]
  then
    CQL="pica.isb=$isbn"
    PPN=$(catmandu convert kxp --query "$CQL" to CSV --header 0 --fix 'retain_field(_id)')
    if [ ! -z "$PPN" ] && [ $(echo "$PPN" | wc -l) -eq 1 ]
    then
        echo -e "PPN\t$PPN"

        # check if item already has PPN (SPARQL may be out of sync)
        CLAIMS=$(wd claims $qid P6721 --lang en)
        if [[ $CLAIMS =~ ^[0-9]+[0-9X]$ ]]
        then
            echo -e "$qid P6721 $CLAIMS"
        else

            # add statement
            wd add-claim "$qid" P6721 "$PPN"
        fi
    fi
  fi
done
