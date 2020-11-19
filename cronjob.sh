#/bin/bash

cd /srv/k10plusbot
./stats.sh >> stats.log
timeout 10m kxpwd.sh
