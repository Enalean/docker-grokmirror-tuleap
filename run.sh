#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "*** error: first argument should be server name or IP"
    exit 1
fi

sed -i "s/%server_name%/$1/g" /etc/grokmirror/repos.conf

echo "==== On tuleap side ==="
echo "** Create a new mirror and set the following sshkey:"
cat ~/.ssh/id_rsa.pub

echo "==== Here ==="
echo "** You can fetch from mirror with /usr/bin/grok-pull -p -c /etc/grokmirror/repos.conf"
echo "** Mirrored repositories are in /var/lib/git/mirror"

exec /bin/bash

#while true; do
#    /usr/bin/grok-pull -p -c /etc/grokmirror/repos.conf
#    sleep 60
#done
