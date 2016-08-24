#!/bin/bash

#run the default config script
source $SABNZBD_HOME/config.sh

#chown the sabnzbd directory by the new user
chown $PUSER:$PGROUP -R $SABNZBD_HOME

# download the latest version of the SickRage-cytec release
# see at https://github.com/cytec/SickRage
echo "Checkout the latest sabnzbd version ..."
[[ ! -d $SABNZBD_HOME/app/.git ]] && gosu $PUSER:$PGROUP bash -c "git clone -b $SABNZBD_BRANCH $SABNZBD_REPO $SABNZBD_HOME/app"

# opt out for autoupdates using env variable
if [ -z "$ADVANCED_DISABLEUPDATES" ]; then
    # update the application
    cd $SABNZBD_HOME/app/ && gosu $PUSER:$PGROUP bash -c "git pull"
fi

# run sabnzbd
echo "Launching sabnzbd ..."
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $SABNZBD_HOME/app/SABnzbd.py -f $SABNZBD_HOME/config -s 0.0.0.0:8080"
