#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "*** error: first argument should be server name or IP"
    exit 1
fi

TULEAP_HOST=$1
MIRROR_PASSWORD=$2
MIRROR_NO=$3

MIRROR_USER="forge__gitmirror_$MIRROR_NO"

# Configure tuleap-gitolite-membership
sed -i "s#%server_name%#$TULEAP_HOST#g" /etc/tuleap-gitolite-membership.ini
sed -i "s/%mirror_user%/$MIRROR_USER/g" /etc/tuleap-gitolite-membership.ini
sed -i "s/%mirror_password%/$MIRROR_PASSWORD/g" /etc/tuleap-gitolite-membership.ini

# Configure grokmirror
sed -i "s#%server_name%#$TULEAP_HOST#g" /etc/grokmirror/repos.conf
sed -i "s#%mirror_no%#$MIRROR_NO#g" /etc/grokmirror/repos.conf

if [ ! -f "/var/lib/gitolite/.ssh/id_rsa" ]; then
    chown -R gitolite.gitolite /var/lib/gitolite
    su -l gitolite -c "ssh-keygen -N '' -f /var/lib/gitolite/.ssh/id_rsa"
    su -l gitolite -c "gitolite setup -pk /var/lib/gitolite/.ssh/id_rsa.pub"
    su -l gitolite -c "gitolite writable @all off 'This is git mirror, no write allowed'"
    rm -rf /var/lib/gitolite/repositories/*
    install -o gitolite -g gitolite -m 0600 /root/.gitolite.rc /var/lib/gitolite/.gitolite.rc

    cat /var/lib/gitolite/.ssh/id_rsa.pub
    exit 0
fi

service sshd start

exec su -l gitolite -c "/start_grokpull.sh $TULEAP_HOST"
