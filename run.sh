#!/bin/bash

set -ex

if [ -z "$1" ]; then
    echo "*** error: first argument should be server name or IP"
    exit 1
fi

TULEAP_HOST=$1
MIRROR_USER=$2
MIRROR_PASSWORD=$3
MIRROR_NO=$4

# Configure tuleap-gitolite-membership
sed -i "s#%server_name%#$TULEAP_HOST#g" /etc/tuleap-gitolite-membership.ini
sed -i "s/%mirror_user%/$MIRROR_USER/g" /etc/tuleap-gitolite-membership.ini
sed -i "s/%mirror_password%/$MIRROR_PASSWORD/g" /etc/tuleap-gitolite-membership.ini

# Configure grokmirror
sed -i "s#%server_name%#$TULEAP_HOST#g" /etc/grokmirror/repos.conf
sed -i "s#%mirror_no%#$MIRROR_NO#g" /etc/grokmirror/repos.conf

service sshd start

exec su -l gitolite -c "/start_grokpull.sh $TULEAP_HOST"
