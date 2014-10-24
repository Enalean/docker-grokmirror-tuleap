FROM centos:centos6

MAINTAINER Manuel Vacelet <manuel.vacelet@enalean.com>

## Install dependencies ##
RUN rpm -i http://mir01.syntis.net/epel/6/i386/epel-release-6-8.noarch.rpm
RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
ADD Tuleap.repo /etc/yum.repos.d/Tuleap.repo

RUN useradd --home /var/lib/gitolite --create-home gitolite

RUN yum install -y --enablerepo=rpmforge-extras python-grokmirror \
    git \
    openssh-server \
    gitolite3 \
    php-cli \
    tuleap-gitolite-membership \
    ; yum clean all

COPY id_rsa_insecure /var/lib/gitolite/.ssh/id_rsa
COPY id_rsa_insecure.pub /var/lib/gitolite/.ssh/id_rsa.pub
RUN chown -R gitolite:gitolite /var/lib/gitolite/.ssh

# Setup gitolite
USER gitolite
#RUN ssh-keygen -N '' -f /var/lib/gitolite/.ssh/id_rsa
RUN USER=gitolite HOME=/var/lib/gitolite gitolite setup -pk /var/lib/gitolite/.ssh/id_rsa.pub
RUN rm -rf /var/lib/gitolite/repositories/*
COPY gitolite.rc /var/lib/gitolite/.gitolite.rc
COPY tuleap-gitolite-membership.ini /etc/tuleap-gitolite-membership.ini

RUN gitolite writable @all off "This is git mirror, no write allowed"

# Grokmirror
COPY repos.conf /etc/grokmirror/repos.conf

# Fix all ownership
USER root
RUN mkdir /var/log/grokmirror /var/lock/grokmirror
RUN chown -R gitolite:gitolite /var/lib/gitolite/.ssh /etc/tuleap-gitolite-membership.ini /etc/grokmirror /var/log/grokmirror /var/lock/grokmirror /var/lib/gitolite/.gitolite.rc
RUN chmod 0700 /var/lib/gitolite/.ssh /var/log/grokmirror /var/lock/grokmirror
RUN chmod 0600 /var/lib/gitolite/.ssh/* /etc/tuleap-gitolite-membership.ini

COPY update_gladmin.sh /usr/local/bin/update_gladmin.sh
COPY run.sh /run.sh
COPY start_grokpull.sh /start_grokpull.sh

ENTRYPOINT [ "/run.sh" ]
