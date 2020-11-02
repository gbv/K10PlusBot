# K10PlusBot

> Interlink Wikidata and K10plus library union catalog.

## Description

This bots uses ISBN numbers to connect Wikidata items and K10plus records with [Wikidata property P6721](https://www.wikidata.org/wiki/Property:P6721). See [the bot's user page](https://www.wikidata.org/wiki/User:K10PlusBot) for details.

## Requirements

* bash
* jq
* wikidata-cli
* catmandu

## Usage

Set up credentials:

    wd config reset
    wd config credentials https://www.wikidata.org

Run bot, optionally with an ISBN prefix such as `3-`:

    ./kxpwd.sh 3-

The script `./stats.sh` will count usage of K10plus property and ISBN properties.

## License

The contents of this repository is published as public domain (Unlicense or CC0).
