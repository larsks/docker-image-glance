FROM larsks/runit:fedora20
MAINTAINER Lars Kellogg-Stedman <lars@oddbit.com>

RUN yum -y install \
	python-pbr \
	git \
	python-devel \
	python-setuptools \
	python-pip \
	gcc \
	libxml2-python \
	libxslt-python \
	python-lxml \
	sqlite \
	python-repoze-lru  \
	crudini \
	yum-utils

# This pulls in all the dependencies of the python-glance package
# without actually installing python-glance (because we're going to install
# that from source).
RUN yum -y install $(repoquery --requires python-glance | awk '{print $1}')
RUN useradd -r -d /srv/glance -m glance

# Download and install glance from source.
WORKDIR /opt
RUN git clone http://github.com/openstack/glance.git
WORKDIR /opt/glance
RUN python setup.py install

ADD install-config.sh /opt/glance/install-config.sh
ADD configure-glance.sh /opt/glance/configure-glance.sh
RUN sh /opt/glance/install-config.sh
RUN sh /opt/glance/configure-glance.sh

RUN sed -i '/publicize_image/ s/:.*/: "",/' /etc/glance/policy.json

ADD glance.sysinit /etc/runit/sysinit/glance
ADD service /service

VOLUME /srv/glance
EXPOSE 9292
EXPOSE 9191

