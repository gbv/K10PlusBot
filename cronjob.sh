#/bin/bash

cd /srv/k10plusbot "" 2000
./stats.sh >> stats.log
timeout 15m kxpwd.sh
