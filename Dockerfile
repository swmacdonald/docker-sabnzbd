FROM alpine:latest
MAINTAINER swmacdonald


ENV \
    # - TERM: The name of a terminal information file from /lib/terminfo, 
    # this file instructs terminal programs how to achieve things such as displaying color.
    TERM="xterm" \

    # - LANG, LANGUAGE, LC_ALL: language dependent settings (Default: en_US.UTF-8)
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \

    # - PKG_*: the needed applications for installation
    GOSU_VERSION="1.9" \
    PKG_BASE="bash tzdata git" \
    PKG_DEV="make gcc g++ automake autoconf python-dev openssl-dev libffi-dev" \
    PKG_PYTHON="ca-certificates py-pip python py-libxml2 py-lxml" \
    PKG_COMPRESS="unrar p7zip" \

    # - SET_CONTAINER_TIMEZONE: set this environment variable to true to set timezone on container startup
    SET_CONTAINER_TIMEZONE="false" \

    # - CONTAINER_TIMEZONE: UTC, Default container timezone as found under the directory /usr/share/zoneinfo/
    CONTAINER_TIMEZONE="UTC" \

    # - SR_HOME: SickRage Home directory
    SABNZBD_HOME="/sabnzbd" \

    # - SABNZBD_REPO, SABNZBD_BRANCH: sabnzbd GitHub repository and related branch
    SABNZBD_REPO="https://github.com/sabnzbd/sabnzbd.git" \
    SABNZBD_BRANCH="1.0.x" \

    # - SABNZBD_DOWNLOADS: main download folder
    SABNZBD_DOWNLOADS="/downloads"


RUN \
    # update the package list
    apk -U upgrade && \

    # install gosu from https://github.com/tianon/gosu
    set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps \
    && \

    # install the needed applications
    apk -U add --no-cache $PKG_BASE $PKG_DEV $PKG_PYTHON $PKG_COMPRESS && \

    # install par2
    git clone --depth 1 https://github.com/Parchive/par2cmdline.git && \
    cd /par2cmdline && \
    aclocal && \
    automake --add-missing && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    cd / && \
    rm -rf par2cmdline && \

    # install additional python packages:
    # setuptools, pyopenssl, cheetah, requirements
    pip --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install --upgrade setuptools && \
    pip --no-cache-dir install --upgrade pyopenssl cheetah requirements requests && \
   # pip install http://www.golug.it/pub/yenc/yenc-0.4.0.tar.gz && \
    pip install http://bitbucket.org/dual75/yenc/get/0.4.0.tar.gz && \
    # download the OpenVPN profiles for Private Internet Access and rename them to
    # be suitable as systemd units
   # apk add --no-cache openvpn curl && \
   # curl -o /openvpn.zip https://www.privateinternetaccess.com/openvpn/openvpn.zip && \
   # unzip -d /etc/openvpn/ /openvpn.zip && \
   # cd /etc/openvpn && \
   # ls -1 *.ovpn | while read f; do echo "mv -f '${f}'" $(echo "${f}" | sed -e 's/.*/\L&/g;s/ovpn/conf/;s/ /-/g'); done | sh && \

    # reference the auth file for Private Internet Access
    #sed -i 's/^auth-user-pass$/\0 \/pia.auth/' /etc/openvpn/*.conf && \


    # remove not needed packages
    apk del $PKG_DEV && \

    # create sabnzbd folder structure
    mkdir -p $SABNZBD_DOWNLOADS/complete && \
    mkdir -p $SABNZBD_DOWNLOADS/incomplete && \
    mkdir -p $SABNZBD_HOME/app && \
    mkdir -p $SABNZBD_HOME/nzbbackups && \
    mkdir -p $SABNZBD_HOME/config && \
    mkdir -p $SABNZBD_HOME/autoProcessScripts && \

    # cleanup temporary files
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*


# set the working directory for sabnzbd
WORKDIR $SABNZBD_HOME/app

#start.sh will download the latest version of SickRage and run it.
COPY *.sh $SABNZBD_HOME/
RUN chmod u+x $SABNZBD_HOME/start.sh

# Set volumes for the sabnzbd folder structure
VOLUME $SABNZBD_HOME/config $SABNZBD_HOME/nzbbackups $SABNZBD_HOME/autoProcessScripts $SABNZBD_DOWNLOADS/complete $SABNZBD_DOWNLOADS/incomplete

# Expose ports
EXPOSE 8080 9090

# Start sabnzbd
#CMD ["/bin/bash", "-c", "$SABNZBD_HOME/start.sh"]
CMD ["/bin/bash"]

