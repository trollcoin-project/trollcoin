#!/bin/bash

# Easy build script for Ubuntu 12.04+
# Tested on 32- and 64-bit Ubuntu, freshly installed from LiveCD with package updates

# Usage: ./trollcoin-build.sh

# If you get the superuser permissions error, run again w/ sudo

# If build is successful:
# trollcoin-qt (GUI) is located in ./trollcoin/
# trollcoind (command line) is located in ./trollcoin/src/

SCRIPTLOCATION=$(readlink -f "$0")
SCRIPTDIR=$(dirname "$SCRIPTLOCATION")
SCRIPTUSER=$SUDO_USER

if [[ $EUID -ne 0 ]]; then
   echo "You must have superuser permissions to build trollcoin"
   exit 100
else
   echo "Superuser check passed"
fi

echo 'Installing dependencies...'
apt-get -y update
apt-get -y install qt4-qmake libqt4-dev build-essential libboost-all-dev libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libminiupnpc-dev
apt-get -y install libdb4.8-dev libdb++-dev

echo 'Building trollcoind'
cd $SCRIPTDIR/src
make -f makefile.unix

echo 'Building trollcoin-qt'
cd $SCRIPTDIR
qmake
make

echo 'Setting file permissions'
chown -R $SCRIPTUSER *

echo 'Done!'
