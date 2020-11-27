---
title: Linking Wikidata and K10plus with K10plusBot
subtitle: SWIB 2020 Lightning Talk
date: 2020-11-18
author:
- Jakob Voß
---

# Example

Linus Torvalds: *Just for Fun* (2001)

----------- -----------------
Wikidata    [Q43395559]
ISBN        3-446-21684-7
K10plus PPN [330720252]
----------- -----------------

[Q43395559]: https://www.wikidata.org/wiki/Q43395559
[330720252]: https://opac.k10plus.de/DB=2.299/PPNSET?PPN=330720252
[P6721]: https://www.wikidata.org/wiki/Property:P6721

# Linking

Item           Property             Value
-------------- -------------------- ---------------
[Q43395559]    [P6721]              [330720252]
*Just for Fun* K10plus edition PPN  

*Link is added as [Wikidata Statement](http://www.wikidata.org/entity/statement/Q43395559-DE68AC74-B842-4400-A4B0-09B01C78F865)*

# How to get a Wikidata Bot

1. Create Wikidata Account (`NAMEBot`)

2. Coding Bot, provide sources in a public repository

3. Documentation and tests

4. Request Bot status

5. Run Bot and regularly check

<https://www.wikidata.org/wiki/Wikidata:Bots>

# Implementation and further Information

* <https://github.com/gbv/K10PlusBot>

* <https://www.wikidata.org/wiki/User:K10PlusBot>

