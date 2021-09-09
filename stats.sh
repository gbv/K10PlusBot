#!/bin/bash
set -e

count () {
  wd sparql <(echo "SELECT (COUNT(?x) AS ?count) { $1 }")
}

distinct () {
  wd sparql <(echo "SELECT (COUNT(DISTINCT ?x) AS ?count) { $1 }")
}

P6721=$(count "?x wdt:P6721 []")
ISBN10=$(count "?x wdt:P957 []")
ISBN13=$(count "?x wdt:P212 []")
ISBN=$(count "{ ?x wdt:P957 [] } UNION { ?x wdt:P212 [] }")
NOKXP=$(count "{ ?x wdt:P957 [] } UNION { ?x wdt:P212 [] } FILTER NOT EXISTS { ?x wdt:P6721 [] }")
CHECKED=$(cat isbn-looked-up-in-kxp.txt doi-looked-up-in-kxp.txt | wc -l)
UNLINKED=$(distinct "{ ?x wdt:P957 [] } UNION { ?x wdt:P212 [] } FILTER NOT EXISTS { ?x wdt:P6721 [] }")
PROCEEDINGS=$(count "?x wdt:P31/wdt:P279* wd:Q1143604 . ?x wdt:P356 []")

echo -e "$(date -Is)\t$P6721\t$ISBN10\t$ISBN13\t$ISBN\t$NOKXP\t$CHECKED\t$UNLINKED\t$PROCEEDINGS"
