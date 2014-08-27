#!/bin/sh

# Install the sample configuration files.
mkdir -p /etc/glance
cp etc/glance-api.conf /etc/glance/glance-api.conf
cp etc/glance-api-paste.ini /etc/glance/glance-api-paste.ini
cp etc/glance-registry.conf /etc/glance/glance-registry.conf
cp etc/glance-registry-paste.ini /etc/glance/glance-registry-paste.ini
cp etc/policy.json /etc/glance/
