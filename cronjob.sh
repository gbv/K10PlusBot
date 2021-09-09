#/bin/bash

date -Is
cd /srv/k10plusbot
./stats.sh >> stats.log

timeout 20m ./kxpwd-doi.sh
timeout 30m ./kxpwd.sh
