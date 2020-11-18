---
title: Verlinkung von Wikidata und K10plus mit dem K10plusBot
subtitle: Bericht aus der Forschung & Entwicklung der VZG
date: 2020-11-18
author:
- Jakob Voß
---

# Motivation

* **Wikidata:** umfassende Wissensdatenbank mit vielen bibliographischen Datensätzen ([WikiCite](http://wikicite.org))

* **K10Plus:** gemeinsamer Verbundkatalog von GBV und SWB: <http://opac.k10plus.de/>

* Kooperation

    1. Verlinkung von Datensätzen zu gleichen Ausgaben
    2. Datenabgleich und Auswertungen

# Beispiel

Linus Torvalds: *Just for Fun* (2001)

----------- -----------------
Wikidata    [Q43395559]
ISBN        3-446-21684-7
K10plus PPN [330720252]
----------- -----------------

[Q43395559]: https://www.wikidata.org/wiki/Q43395559
[330720252]: https://opac.k10plus.de/DB=2.299/PPNSET?PPN=330720252
[P6721]: https://www.wikidata.org/wiki/Property:P6721

# Verlinkung

Item           Property             Value
-------------- -------------------- ---------------
[Q43395559]    [P6721]              [330720252]
*Just for Fun* K10plus edition PPN  

*Eintrag per [Wikidata-Statement](http://www.wikidata.org/entity/statement/Q43395559-DE68AC74-B842-4400-A4B0-09B01C78F865)*

# Der Weg zum Bot

1. Wikidata-Account erstellen (`NAMEBot`)

2. Bot programmieren und Quellcode bereitstellen

3. Bot dokumentieren und testen

4. Bot-Status beantragen

5. Bot laufen lassen und überwachen

<https://www.wikidata.org/wiki/Wikidata:Bots>

# Implementierung und weitere Informationen

* <https://github.com/gbv/K10PlusBot>

* <https://www.wikidata.org/wiki/User:K10PlusBot>

