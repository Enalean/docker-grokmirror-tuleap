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
