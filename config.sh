#!/bin/bash

PUID=${PUID:=15000}
PUSER=${PUSER:=sabnzbd}
PGID=${PGID:=15000}
PGROUP=${PGROUP:=sabnzbd}

#Create internal sabnzbd user (which will be mapped to external user and used to run the process)
#create group similar to: 
#  addgroup --gid $PGID $PGROUP
addgroup -g $PGID $PGROUP

#create user similar to:
#  adduser --shell /bin/bash --no-create-home --uid $PUID --ingroup $PGROUP --disabled-password --gecos "" $PUSER
adduser -s /bin/bash -H -u $PUID -G $PGROUP -D -g "" $PUSER

#set the timezone
source $SABNZBD_HOME/set_timezone.sh