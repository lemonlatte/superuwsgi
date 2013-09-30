#!/bin/sh

BASE_PATH=$(dirname $(readlink -f "$0"))

apt-get -y install python-software-properties curl git
curl -L http://bootstrap.saltstack.org | sudo sh -s -- git 5324d6

if [ -d /srv ] || [ -L /srv ]; then
    rm -rf /srv
fi
ln -s $BASE_PATH/srv /srv

salt-call state.highstate --local
