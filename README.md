# K10PlusBot

> Interlink Wikidata and K10Plus library union catalog.

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

The current version only checks 10 ISBN found in Wikidata.

## License

The contents of this repository is published as public domain (Unlicense or CC0).
