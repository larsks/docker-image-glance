#!/bin/sh

######################################################################
##
## GLANCE-API
##

crudini --del /etc/glance/glance-api.conf \
	DEFAULT \
	log_file
crudini --set /etc/glance/glance-api.conf \
	DEFAULT \
	verbose \
	true
crudini --set /etc/glance/glance-api.conf \
	DEFAULT \
	filesystem_store_datadir \
	/srv/glance/images/

## Database
crudini --set /etc/glance/glance-api.conf \
	database \
	connection \
	sqlite:////srv/glance/glance.db

## Message queue
crudini --set /etc/glance/glance-api.conf \
	DEFAULT \
	rpc_backend \
	rabbit
crudini --set /etc/glance/glance-api.conf \
	DEFAULT \
	rabbit_host \
	amqphost

##
## Configure keystone credentials
##
crudini --set /etc/glance/glance-api.conf \
	keystone_authtoken \
	auth_uri \
	http://keystone:35357/v2.0
crudini --set /etc/glance/glance-api.conf \
	keystone_authtoken \
	admin_tenant_name \
	services
crudini --set /etc/glance/glance-api.conf \
	keystone_authtoken \
	admin_user \
	glance
crudini --set /etc/glance/glance-api.conf \
	keystone_authtoken \
	admin_password \
	glance
crudini --del /etc/glance/glance-api.conf \
	keystone_authtoken \
	auth_host
crudini --del /etc/glance/glance-api.conf \
	keystone_authtoken \
	auth_port
crudini --del /etc/glance/glance-api.conf \
	keystone_authtoken \
	auth_protocol

######################################################################
##
## GLANCE-REGISTRY
##

crudini --del /etc/glance/glance-registry.conf \
	DEFAULT \
	log_file
crudini --set /etc/glance/glance-registry.conf \
	DEFAULT \
	verbose \
	true

## Database
crudini --set /etc/glance/glance-registry.conf \
	database \
	connection \
	sqlite:////srv/glance/glance.db

##
## Configure keystone credentials
##
crudini --set /etc/glance/glance-registry.conf \
	keystone_authtoken \
	auth_uri \
	http://keystone:35357/v2.0
crudini --set /etc/glance/glance-registry.conf \
	keystone_authtoken \
	admin_tenant_name \
	services
crudini --set /etc/glance/glance-registry.conf \
	keystone_authtoken \
	admin_user \
	glance
crudini --set /etc/glance/glance-registry.conf \
	keystone_authtoken \
	admin_password \
	glance
crudini --del /etc/glance/glance-registry.conf \
	keystone_authtoken \
	auth_host
crudini --del /etc/glance/glance-registry.conf \
	keystone_authtoken \
	auth_port
crudini --del /etc/glance/glance-registry.conf \
	keystone_authtoken \
	auth_protocol
