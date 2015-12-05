FROM centos:7
MAINTAINER Andy Neff <andyneff@users.noreply.github.com>

RUN yum install -y epel-release &&\
    yum install -y haveged

CMD haveged -F