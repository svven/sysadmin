#!/bin/bash
echo "
##############################################################################
## Git clone private repo
## User: $USER (e.g.: root, vagrant, ubuntu)
##############################################################################"
if [ $# -lt 2 ]; then
    echo "## Missing arguments:
##   1 - Private repo (e.g.: git@github.com:svven/provision.git)
##   2 - Deployment key (i.e. URL to id_rsa)
##############################################################################"
    exit 1
fi

GIT_REPO=$1; DEPLOYMENT_KEY=$2
DIR=$( cd "$( dirname "$0" )" && pwd )

## Go home
cd $HOME # /home/$USER

## Set deployment key
sudo -u $USER -H bash $DIR/setssh.sh $DEPLOYMENT_KEY

## Start the profile
source .bash_profile

## Get private repo
git clone $GIT_REPO
