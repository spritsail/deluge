#! /bin/sh

rm -f /config/deluge/deluged.pid

deluged -c /config/deluge -L info -l /config/deluge/deluged.log
deluge-web -c /config/deluge