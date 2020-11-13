#!/bin/bash
set -e

PREFIX=$1       # optional ISBN prefix
LIMIT=${2:-20}  # how many ISBN to query at most

if [ -z "$PREFIX" ]
then
    echo "Please consider adding an ISBN-prefix as first argument"
fi

# make sure the script is run as user K0PlusBot (requires plain-text credential)
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
  if [ -z "$isbn" ]; then continue; fi  # empty line
  echo -e "ISBN\t$isbn"

  # ISBN was already looked up in K10plus without success (or with multiple hits)
  if grep -q "$isbn" isbn-not-found-in-kxp.txt; then continue; fi

  # Query for ISBN in K10Plus via SRU (see `catmandu.yaml` for config)
  CQL="pica.isb=$isbn"
  PPN=$(catmandu convert kxp --query "$CQL" to plain --fix 'retain_field(_id)')

  # if there is exactely one PPN
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

:<<GRAPH
flowchart TD
  1(check user account) -->|ok| 2
  2(query edition items<br/> with ISBN<br/>but no K10plus PPN) --> loop
  subgraph loop[for each QID,ISBN]
    A(ISBN already looked up?) --> |no| B(look up ISBN in K10plus)
    B --> C(exactely one PPN found?)
    C -->|yes| D(item QID already has K10Plus PPN?)
    D -->|no| E(Add claim with PPN to QID)
  end
GRAPH
