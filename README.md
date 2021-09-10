# K10PlusBot

> Interlink Wikidata and K10plus library union catalog

## Description

This bot adds and uses Wikidata items with [Property P6721 (K10Plus PPN)](https://www.wikidata.org/wiki/Property:P6721). To interlink and align Wikidata and K10plus library union catalog. See [the bot's user page](https://www.wikidata.org/wiki/User:K10PlusBot) for additional information and status.

## Publications

The subdirectory `docs/` contains publications about the Bot:

* *Verlinkung von Wikidata und K10plus mit dem K10plusBot* (2020-11-18) https://doi.org/10.5446/50003. Short presentation in German (9:20).
* *Linking K10plus library union catalog with Wikidata* (2020-) Lightning talk at [SWIB 2020 conference](http://swib.org/swib20/): recording [at YouTube](https://www.youtube.com/watch?v=YNI6ty4gpDw) (03:58).

## Requirements

The bot requires a Unix system with:

* bash
* jq
* wikidata-cli
* catmandu
* meermaid (only for documentation)

Further recommended:

* miller

## Installation

### Dependencies

On Ubuntu this should work:

~~~bash
sudo apt-get install jq miller
sudo apt-get install libcatmandu-perl libcatmandu-sru-perl cpanminus
sudo cpanm Catmandu::PICA
sudo apt-get install nodejs npm
sudo npm install -g wikibase-cli
~~~

### Clone this repository

~~~bash
git clone https://github.com/gbv/K10PlusBot.git
cd K10PlusBot
~~~

### Set up credentials

    wd config reset
    wd config credentials https://www.wikidata.org

Add field `user` with value `K10PlusBot` to the config file (`wd config path`).

## Scripts and their usage

### kxpwd

Add K10plus PPN statements based on existing ISBN statements.

Run bot, optionally with an ISBN prefix such as `3-` and a maximum number of ISBNs as second argument:

    ./kxpwd.sh 3- 1000

Processed ISBN are logged to `isbn-looked-up-in-kxp.txt` and `isbn-not-found-in-kxp.txt`.

### kxpwd-doi

Add K10plus PPN statements based on existing DOI statements. By now only proceedings (Q1143604) are include. See [this SPARQL query](https://w.wiki/43AB) to get the number of proceedings items with DOI.

Run bot, optionally with a DOI prefix and a maximum number of DOIs as second argument.

Processed DOI are logged to `doi-looked-up-in-kxp.txt`.

### stats

`./stats.sh` counts usage of K10plus property and ISBN properties.

### remove-human-claims

Remove K10plus PPPN statements on items about humans (Q5) because the property should only be used on bibliographic records.

## License

The contents of this repository is published as public domain (Unlicense or CC0).
