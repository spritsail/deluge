#Deluge
A dockerfile to run Deluge torent client, based on Alpine Linux. It expects a  partition to store data mapped to /config in the container, and a volume where your torrents should go stored at /media. Enjoy!

This dockerfile uses a user with uid 647. Make sure this user has write access to the /config folder. 
##Example run command
`docker run -d --restart=always --name SyncThing --volumes-from Data --volumes-from media -p 51360:51360/udp -p 8112:8112 -p 58846:58846 adamant/deluge`
