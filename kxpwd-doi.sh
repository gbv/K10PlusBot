#!/bin/bash
set -e

PREFIX=$1       # optional DOI prefix
LIMIT=$2        # how many DOI to query at most
DELAY=5s        # between edits

if [ -z "$PREFIX" ]
then
    echo "Please consider adding a DOI-prefix as first argument"
fi

if [ -z "$LIMIT" ]
then
    echo "Please consider adding a LIMIT as second argument"
else
    LIMIT="LIMIT $LIMIT"
fi

# make sure the script is run as user K0PlusBot
USER=$(wd config -j | jq -r .user)
if [ "$USER" != "K10PlusBot" ]
then
    echo "Script must be run with K10PlusBot credentials, run 'wd config'!"
    exit
fi

# search for proceeding items with DOI and no K10Plus PPN
tee query.rql <<SPARQL
SELECT ?qid ?doi {
  ?qid wdt:P31/wdt:P279* wd:Q1143604 .
  ?qid wdt:P356 ?doi .
  FILTER( STRSTARTS( ?doi, "$PREFIX" ) ) .
  FILTER NOT EXISTS { ?qid wdt:P6721 ?ppn }
} $LIMIT
SPARQL

wd sparql -f table query.rql | tail -n +2 | \
while read qid doi
do
  echo -e "DOI\t$doi"

  # DOI was already looked up in K10plus without success (or with multiple hits)
  if grep -q "$doi" doi-looked-up-in-kxp.txt; then continue; fi

  # Query for DOI in K10Plus via SRU (see `catmandu.yaml` for config)
  # escape / in DOI for CQL query
  CQL=$(echo "pica.doi=\"$doi\"" | sed 's|/|\\\\\\/|g')

  PPN=$(catmandu convert kxp --query "$CQL" to plain --fix 'retain_field(_id)')

  HITS=$(echo "$PPN" | wc -l)
  if [ -z "$PPN" ]; then
    HITS=0
  fi

  # if there is exactely one PPN
  if [ "$HITS" -eq 1 ]
  then
      echo -e "PPN\t$PPN\tQID\t$qid"

      # check if item already has PPN (SPARQL may be out of sync)
      CLAIMS=$(wd claims $qid P6721 --lang en)
      if [[ $CLAIMS =~ ^[0-9]+[0-9X]$ ]]
      then
          echo -e "$qid P6721 $CLAIMS"
      else

          # add statement
          wd add-claim "$qid" P6721 "$PPN"
          sleep $DELAY
      fi
  else
      echo "$doi $HITS" | tee -a doi-looked-up-in-kxp.txt
  fi
done
