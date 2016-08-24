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
