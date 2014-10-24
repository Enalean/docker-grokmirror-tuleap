#!/bin/bash

set -e

TULEAP_HOST=$1

ssh -oStrictHostKeyChecking=no gitolite@$TULEAP_HOST info

/usr/bin/grok-pull -v -r -p -c /etc/grokmirror/repos.conf || true

while true; do
    /usr/bin/grok-pull -v -r -p -c /etc/grokmirror/repos.conf || true
    sleep 10
done
