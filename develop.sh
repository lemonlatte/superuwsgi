#!/bin/sh

wget -O - http://bootstrap.saltstack.org | sh
if [ ! -d /srv ]; then
    ln -s `pwd`/srv /srv
fi
salt-call state.highstate --local
