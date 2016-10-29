# docker-sabnzbd
a minimal sabnzb docker installation based on latest alpine 


```
docker create --name=sabnzbd --restart=always \
-v <your downloads folder>:/downloads/complete \
-v <your incomplete downloads folder>:/downloads/incomplete \
-v <your sabnzbd config folder>:/sabnzbd/config \
-v <your nzb backup folder>:/sabnzbd/nzbbackups \
-v <your post processing scripts folder>:/sabnzbd/autoProcessScripts \
-e PGID=<GROUP ID> -e PUID=<USER ID> \
-p <HTTP PORT>:8080 -p <HTTPS PORT>:9090 \
swmacdonald/sabnzbd
```


sabnzbd
===================================

Example usage:

    docker run -d \
        -p 8080:8080 \
        -p 9090:9090\
        --dns=209.22.18.222 \
        --dns=209.22.18.218 \
        -e RT_UID=1000 \
        -e RT_GID=1000 \
        

Environment Variables
---------------------

- ``RT_UID``: Numeric user ID to assign to the sabnzbd user
- ``RT_GID``: Numeric group ID to assign to the sabnzb user

Notes
-----

- The DNS options are there to protect against DNS requests leaking. You may
  use whatever DNS servers you wish.
