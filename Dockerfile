FROM centos:centos6

MAINTAINER Manuel Vacelet <manuel.vacelet@enalean.com>

RUN yum update -y; yum clean all

## Install dependencies ##
RUN rpm -i http://mir01.syntis.net/epel/6/i386/epel-release-6-8.noarch.rpm

RUN yum install -y python-grokmirror; yum clean all

#ADD Tuleap.repo /etc/yum.repos.d/Tuleap.repo
#RUN yum install -y gitolite3; yum clean all
#RUN yum install -y tuleap-gitolite-membership; yum clean all

RUN useradd mirror

RUN mkdir /var/log/mirror
RUN chown mirror:mirror /var/log/mirror
RUN mkdir -p /var/lib/git/mirror
RUN chown mirror:mirror /var/lib/git/mirror
RUN mkdir /var/lock/mirror/
RUN chown mirror:mirror /var/lock/mirror/

# Use default SSH key
ADD id_rsa_insecure /home/mirror/.ssh/id_rsa
ADD id_rsa_insecure.pub /home/mirror/.ssh/id_rsa.pub
RUN chown -R mirror:mirror /home/mirror/.ssh
RUN chmod 0700 /home/mirror/.ssh
RUN chmod 0600 /home/mirror/.ssh/*

ADD run.sh /run.sh
ADD repos.conf /etc/grokmirror/repos.conf
RUN chown -R mirror:mirror /etc/grokmirror

USER mirror
WORKDIR /home/mirror

ENTRYPOINT [ "/run.sh" ]
