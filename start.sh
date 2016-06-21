#! /bin/sh

rm -f /config/deluge/deluged.pid

deluged -c /config/deluge -L info -l /dev/stdout
deluge-web -c /config/deluge