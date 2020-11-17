# K10PlusBot

> Interlink Wikidata and K10plus library union catalog.

## Description

This bots uses ISBN numbers to connect Wikidata items and K10plus records with [Wikidata property P6721](https://www.wikidata.org/wiki/Property:P6721). See [the bot's user page](https://www.wikidata.org/wiki/User:K10PlusBot) for details.

## Requirements

The bot requires a Unix system with:

* bash
* jq
* wikidata-cli
* catmandu
* meermaid (only for documentation)

## Installation

### Dependencies

On Ubuntu this should work:

~~~bash
sudo apt-get install jq 
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

## Scripts and their usage

### kxpwd

Add K10plus PPN statements based on existing ISBN statements.

Run bot, optionally with an ISBN prefix such as `3-`:

    ./kxpwd.sh 3-

Second argument is maximum number of identifiers to retrieve.

### stats

`./stats.sh` will count usage of K10plus property and ISBN properties.

### remove-human-claims

Remove K10plus PPPN statements on items about humans (Q5). The property should only be used on bibliographic records.

## License

The contents of this repository is published as public domain (Unlicense or CC0).
