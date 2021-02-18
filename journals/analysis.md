# Mapping K10plus Journals and Wikidata

## Journal records

Wikidata contains more than 100.000 items about academic journals (and more about other kinds of periodicals):

~~~sh
echo "SELECT (COUNT(?j) AS ?c) { ?j wdt:P31/wdt:P279* wd:Q5633421 }" | wd s /dev/stdin
~~~

Only some are also mapped to K10Plus:

~~~sh
echo "SELECT (COUNT(?j) AS ?c) { ?j wdt:P31/wdt:P279* wd:Q5633421 .  ?j wdt:P6721 [] }" | wd s /dev/stdin
~~~

## Journal Identifiers

Wikidata contains around 60 types of [identifiers for academic journals](Q57589544):

~~~sh
wdtaxonomy -i Q57589544
~~~

Most of interest are [ZDB-ID](P1042), [OCLC number](P243), and  [ISSN](P7363) because these number are also used in K10plus:

ZDB-ID:

~~~sh
echo "SELECT (COUNT(?j) AS ?c) { ?j wdt:P1042 [] }" | wd s /dev/stdin
~~~

OCLC-ID:

~~~sh
echo "SELECT (COUNT(?j) AS ?c) { ?j wdt:P243 [] }" | wd s /dev/stdin
~~~

ISSN-L (groups multiple publication types under one ISSN, normal ISSN may also be of interest):

~~~sh
echo "SELECT (COUNT(?j) AS ?c) { ?j wdt:P7363 [] }" | wd s /dev/stdin
~~~

