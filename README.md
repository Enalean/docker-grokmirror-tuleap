Docker image to test tuleap grokmirror
======================================

Be careful, it's meant for test only, there are ssh keys that must not be used
elsewhere, esp. in prod!

How to use
----------

For first run, check specific section below

Regular run
```````````

    docker run -d --name=mirror1 --volumes-from mirror1-data enalean/grokmirror-tuleap red.tuleap-aio-dev.dev.docker welcome0 1

Where:

* red.tuleap-aio-dev.dev.docker is the hostname of your Tuleap server
* welcome0 is the password of this user
* 1 is the ID of the mirror

First run
`````````

Create a data container for your mirror:

    docker run --name=mirror1-data -v /var/lib/gitolite busybox true

Then initialize data:

    docker run -ti --rm x--volumes-from mirror1-data enalean/grokmirror-tuleap red.tuleap-aio-dev.dev.docker welcome0 1

Where:

* red.tuleap-aio-dev.dev.docker is the hostname of your Tuleap server
* welcome0 is the password of this user
* 1 is the ID of the mirror

A public ssh key is displayed on terminal at first run, publish it for the
mirror on Tuleap.

Wait for a minute of two so the key is dumped on the FS.



