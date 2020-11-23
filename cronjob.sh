#/bin/bash

date -Is
cd /srv/k10plusbot
./stats.sh >> stats.log
timeout 15m ./kxpwd.sh
