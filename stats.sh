#!/bin/bash
set -e

count () {
  wd sparql <(echo "SELECT (COUNT(?x) AS ?count) { $1 }")
}

P6721=$(count "?x wdt:P6721 []")
ISBN10=$(count "?x wdt:P957 []")
ISBN13=$(count "?x wdt:P212 []")
ISBN=$(count "{ ?x wdt:P957 [] } UNION { ?x wdt:P212 [] }")
NOKXP=$(count "{ ?x wdt:P957 [] } UNION { ?x wdt:P212 [] } FILTER NOT EXISTS { ?x wdt:P6721 [] }")
CHECKED=$(wc -l < isbn-looked-up-in-kxp.txt)

echo -e "$(date -Is)\t$P6721\t$ISBN10\t$ISBN13\t$ISBN\t$NOKXP\t$CHECKED"
