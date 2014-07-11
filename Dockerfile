FROM larsks/runit
MAINTAINER lars@oddbit.com

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

# Download and install glance from source.
WORKDIR /opt
RUN git clone http://github.com/openstack/glance.git
WORKDIR /opt/glance
RUN python setup.py install

# Install the sample configuration files.
RUN mkdir -p /etc/glance
RUN cp etc/glance-api.conf /etc/glance/glance-api.conf
RUN cp etc/glance-api-paste.ini /etc/glance/glance-api-paste.ini
RUN cp etc/glance-registry.conf /etc/glance/glance-registry.conf
RUN cp etc/glance-registry-paste.ini /etc/glance/glance-registry-paste.ini
RUN cp etc/policy.json /etc/glance/

######################################################################
##
## GLANCE-API
##

RUN crudini --del /etc/glance/glance-api.conf \
	DEFAULT \
	log_file
RUN crudini --set /etc/glance/glance-api.conf \
	DEFAULT \
	verbose \
	true
RUN crudini --set /etc/glance/glance-api.conf \
	DEFAULT \
	filesystem_store_datadir \
	/srv/glance/images/

## Database
RUN crudini --set /etc/glance/glance-api.conf \
	database \
	connection \
	sqlite:////srv/glance/glance.db

## Message queue
RUN crudini --set /etc/glance/glance-api.conf \
	DEFAULT \
	rpc_backend \
	rabbit
RUN crudini --set /etc/glance/glance-api.conf \
	DEFAULT \
	rabbit_host \
	amqphost

##
## Configure keystone credentials
##
RUN crudini --set /etc/glance/glance-api.conf \
	keystone_authtoken \
	auth_uri \
	http://keystone:35357/v2.0
RUN crudini --set /etc/glance/glance-api.conf \
	keystone_authtoken \
	admin_tenant_name \
	services
RUN crudini --set /etc/glance/glance-api.conf \
	keystone_authtoken \
	admin_user \
	glance
RUN crudini --set /etc/glance/glance-api.conf \
	keystone_authtoken \
	admin_password \
	glance
RUN crudini --del /etc/glance/glance-api.conf \
	keystone_authtoken \
	auth_host
RUN crudini --del /etc/glance/glance-api.conf \
	keystone_authtoken \
	auth_port
RUN crudini --del /etc/glance/glance-api.conf \
	keystone_authtoken \
	auth_protocol

######################################################################
##
## GLANCE-REGISTRY
##

RUN crudini --del /etc/glance/glance-registry.conf \
	DEFAULT \
	log_file
RUN crudini --set /etc/glance/glance-registry.conf \
	DEFAULT \
	verbose \
	true

## Database
RUN crudini --set /etc/glance/glance-registry.conf \
	database \
	connection \
	sqlite:////srv/glance/glance.db

##
## Configure keystone credentials
##
RUN crudini --set /etc/glance/glance-registry.conf \
	keystone_authtoken \
	auth_uri \
	http://keystone:35357/v2.0
RUN crudini --set /etc/glance/glance-registry.conf \
	keystone_authtoken \
	admin_tenant_name \
	services
RUN crudini --set /etc/glance/glance-registry.conf \
	keystone_authtoken \
	admin_user \
	glance
RUN crudini --set /etc/glance/glance-registry.conf \
	keystone_authtoken \
	admin_password \
	glance
RUN crudini --del /etc/glance/glance-registry.conf \
	keystone_authtoken \
	auth_host
RUN crudini --del /etc/glance/glance-registry.conf \
	keystone_authtoken \
	auth_port
RUN crudini --del /etc/glance/glance-registry.conf \
	keystone_authtoken \
	auth_protocol

RUN sed -i '/publicize_image/ s/:.*/: "",/' /etc/glance/policy.json

RUN useradd -r -d /srv/glance -m glance

VOLUME /srv/glance
EXPOSE 9292
EXPOSE 9191

