FROM centos:centos6

MAINTAINER Manuel Vacelet <manuel.vacelet@enalean.com>

## Install dependencies ##
RUN yum install -y epel-release
COPY Tuleap.repo /etc/yum.repos.d/Tuleap.repo

RUN useradd --home /var/lib/gitolite --create-home gitolite

RUN yum install -y python-grokmirror \
    git19-git \
    openssh-server \
    gitolite3 \
    php-cli \
    tuleap-gitolite-membership \
    ; yum clean all

# Make a ssh key
RUN service sshd start

# Setup gitolite
COPY gitolite.rc /root/.gitolite.rc

# Setup tuleap-gitolite-membership
COPY tuleap-gitolite-membership.ini /etc/tuleap-gitolite-membership.ini

# Grokmirror
COPY repos.conf /etc/grokmirror/repos.conf

# Fix all ownership
RUN mkdir /var/log/grokmirror /var/lock/grokmirror
RUN chown -R gitolite:gitolite /etc/tuleap-gitolite-membership.ini /etc/grokmirror /var/log/grokmirror /var/lock/grokmirror

COPY update_gladmin.sh /usr/local/bin/update_gladmin.sh
COPY run.sh /run.sh
COPY start_grokpull.sh /start_grokpull.sh

VOLUME [ "/var/lib/gitolite" ]

ENTRYPOINT [ "/run.sh" ]
