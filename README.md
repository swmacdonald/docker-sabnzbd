# docker-sabnzbd
a minimal sabnzb docker installation based on alpine 3.4

[![](https://images.microbadger.com/badges/version/netleader/sabnzbd.svg)](http://microbadger.com/images/netleader/sabnzbd "Get your own version badge on microbadger.com")

[![](https://images.microbadger.com/badges/image/netleader/sabnzbd.svg)](http://microbadger.com/images/netleader/sabnzbd "Get your own image badge on microbadger.com")

```
docker create --name=sabnzbd --restart=always \
-v <your downloads folder>:/downloads/complete \
-v <your incomplete downloads folder>:/downloads/incomplete \
-v <your sabnzbd config folder>:/sabnzbd/config \
-v <your nzb backup folder>:/sabnzbd/nzbbackups \
-v <your post processing scripts folder>:/sabnzbd/autoProcessScripts \
-e PGID=<GROUP ID> -e PUID=<USER ID> \
-p <HTTP PORT>:8080 -p <HTTPS PORT>:9090 \
netleader/sabnzbd
```


Docker container running rTorrent and ruTorrent behind Apache and using a Private Internet Access VPN.

Example usage:

docker run -d \
    -p 8080:80 \
    --cap-add=NET_ADMIN \
    --dns=209.22.18.222 \
    --dns=209.22.18.218 \
    -v ~/Downloads/torrents:/torrents \
    -v ~/.config/rutorrent:/app/rutorrent \
    -v ~/Downloads/watch:/watch \
    -e PIA_USER=<user> \
    -e PIA_PASS=<password> \
    -e PIA_PROFILE=<gateway> \
    -e RT_UID=1000 \
    -e RT_GID=1000 \
    --name rutorrent \
    codekoala/rutorrent
Environment Variables

PIA_USER: your PIA username
PIA_PASS: your PIA password
PIA_PROFILE: the name of the PIA OpenVPN profile to use (see https://www.privateinternetaccess.com/pages/client-support/ for options)
RT_UID: Numeric user ID to assign to the rtorrent user
RT_GID: Numeric group ID to assign to the rtorrent user
