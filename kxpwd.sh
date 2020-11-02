#!/bin/bash
set -e

LIMIT=20
PREFIX=$1

if [ -z "$PREFIX" ]
then
    echo "Please consider adding an ISBN-prefix as first argument"
fi

USER=$(wd config -j | jq -r '.credentials["https://www.wikidata.org"].username')
if [ "$USER" != "K10PlusBot" ]
then
    echo "Script must be run with K10PlusBot credentials, run 'wd config'!"
    exit
fi

# search for edition items with ISBN-10 or ISBN-13 and no K10Plus PPN
tee query.rql <<SPARQL
SELECT ?qid ?isbn {
  { { ?qid wdt:P957 ?isbn } UNION { ?qid wdt:P212 ?isbn } }
  ?qid wdt:P279*/wdt:P31 wd:Q3331189 .
  FILTER( STRSTARTS( ?isbn, "$PREFIX" ) ) .
  FILTER NOT EXISTS { ?qid wdt:P6721 ?ppn }
} LIMIT $LIMIT
SPARQL

wd sparql query.rql | jq -r '.[]|[.qid,.isbn]|@tsv' | \
while IFS=$'\t' read qid isbn
do
  echo -e "ISBN\t$isbn"
  if [ -z "$isbn" ]; then continue; fi
  if grep -q "$isbn" isbn-not-found-in-kxp.txt; then continue; fi

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
  else
      echo "$isbn" >> isbn-not-found-in-kxp.txt
  fi
done
