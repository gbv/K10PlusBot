#!/bin/bash
set -e

count () {
  wd sparql <(echo "SELECT (COUNT(?item) AS ?count) { ?item wdt:$1 ?value }")
}

# PPN,ISBN-10,ISBN-13
echo -e "$(date '+%Y-%m-%d')\t$(count P6721)\t$(count P957)\t$(count P212)"
