#!/bin/bash
set -e

PREFIX=$1       # optional ISBN prefix
LIMIT=$2        # how many ISBN to query at most
DELAY=5s        # between edits

if [ -z "$PREFIX" ]
then
    echo "Please consider adding an ISBN-prefix as first argument"
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

# search for edition items with ISBN-10 or ISBN-13 and no K10Plus PPN
tee query.rql <<SPARQL
SELECT ?qid ?isbn {
  { { ?qid wdt:P957 ?isbn } UNION { ?qid wdt:P212 ?isbn } }
  { 
    { ?qid wdt:P279*/wdt:P31 wd:Q3331189 } # edition
    UNION {
      ?qid wdt:P31 wd:Q20540385 ;
           wdt:P123 ?publisher ;
           wdt:P577 ?year .
      FILTER (YEAR(?year) >= 1967) 
    } # recent non-fiction books with publisher
  }
  FILTER( STRSTARTS( ?isbn, "$PREFIX" ) ) .
  FILTER NOT EXISTS { ?qid wdt:P6721 ?ppn }
} $LIMIT
SPARQL

wd sparql -f table query.rql | tail -n +2 | \
while read qid isbn
do
  echo -e "ISBN\t$isbn"

  # ISBN was already looked up in K10plus without success (or with multiple hits)
  if grep -q "$isbn" isbn-looked-up-in-kxp.txt; then continue; fi

  # Query for ISBN in K10Plus via SRU (see `catmandu.yaml` for config)
  CQL="pica.isb=$isbn"
  PPN=$(catmandu convert kxp --query "$CQL" to plain --fix 'retain_field(_id)')

  HITS=$(echo "$PPN" | wc -l)
  if [ -z "$PPN" ]; then
    HITS=0
  fi

  # if there is exactely one PPN
  if [ "$HITS" -eq 1 ]
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
          sleep $DELAY
      fi
  else
      echo "$isbn $HITS" >> isbn-looked-up-in-kxp.txt
  fi
done
