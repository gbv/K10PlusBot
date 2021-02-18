# Mapping K10plus Journals and Wikidata

## Journal records

Wikidata contains more than 100.000 items about academic journals (and more about other kinds of periodicals):

~~~sh
echo "SELECT (COUNT(?j) AS ?c) { ?j wdt:P31/wdt:P279* wd:Q5633421 }" | wd s /dev/stdin
~~~

Only some are also mapped to K10Plus via Wikidata property [P6721](P6721):

~~~sh
echo "SELECT (COUNT(?j) AS ?c) { ?j wdt:P31/wdt:P279* wd:Q5633421 . ?j wdt:P6721 [] }" | wd s /dev/stdin
~~~

## Journal Identifiers

Wikidata contains around 60 types of [identifiers for academic journals](Q57589544):

~~~sh
wdtaxonomy -i Q57589544
~~~

Most of interest are [ZDB-ID](P1042), [OCLC number](P243), and  [ISSN](P7363) because these number are also used in K10plus:

ZDB-ID:

~~~sh
wd q -c -p P1042
~~~

OCLC-ID:

~~~sh
wd q -c -p P243
~~~

ISSN-L (groups multiple publication types under one ISSN, normal ISSN may also be of interest):

~~~sh
wd q -c -p P7363
~~~

## Mapping journal records

To align K10Plus and Wikidata journal records we can look up known identifiers (ZDB-ID, OCLC-ID, ISSN) and check back by comparing the journal title and start/end years. More records can be aligned based on journal title but this likely requires manual quality control.

## Use cases

* Show additional journal ids in the catalog (e.g. DBLP, JournalTOCs...)
* Enrich subject indexing of journals
* ...
