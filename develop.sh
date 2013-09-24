#!/bin/sh

curl -L http://bootstrap.saltstack.org | sudo sh -s -- git develop
if [ -d /srv ]; then
    rm -rf /srv
fi
ln -s `pwd`/srv /srv
salt-call state.highstate --local
