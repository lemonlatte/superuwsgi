#!/bin/sh

wget -O - http://bootstrap.saltstack.org | sh
ln -s `pwd`/srv /srv
salt-call state.highstate --local
