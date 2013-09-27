#!/bin/sh

apt-get -y install python-software-properties
curl -L http://bootstrap.saltstack.org | sudo sh -s -- git 5324d6
if [ -d /srv ]; then
    rm -rf /srv
fi
ln -s `pwd`/srv /srv
salt-call state.highstate --local
# salt-call state.sls webapp.uwsgi --local
