[hub]: https://hub.docker.com/r/spritsail/deluge
[git]: https://github.com/spritsail/deluge
[drone]: https://drone.spritsail.io/spritsail/deluge
[mbdg]: https://microbadger.com/images/spritsail/deluge

# [spritsail/NZBGet][hub]

[![](https://images.microbadger.com/badges/image/spritsail/deluge.svg)][mbdg]
[![Latest Version](https://images.microbadger.com/badges/version/spritsail/deluge.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/spritsail/deluge.svg)][git]
[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/deluge.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/deluge.svg)][hub]
[![Build Status](https://drone.spritsail.io/api/badges/spritsail/deluge/status.svg)][drone]

# [spritsail/Deluge][hub]
A dockerfile to run the Deluge torent client, based on Alpine Linux.  
It expects a  partition to store data mapped to /config in the container, and a volume where your torrents should go stored at /media. Enjoy!

This dockerfile uses a user with uid 902, and a gid of 900. Make sure this user has write access to the /config folder.
The uid can be overridden by the environment variables `$UID` and `$GID` respectively.

## Example run command
`docker run -d --restart=always --name Deluge -v /volumes/deluge:/confg -v /mnt/media:/media -p 51360:51360/udp -p 8112:8112 -p 58846:58846 spritsail/deluge`
