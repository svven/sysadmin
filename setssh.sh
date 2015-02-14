#!/bin/bash
echo "
##############################################################################
## Set SSH keys
## User: $USER (e.g.: ubuntu, svven, ducu, jon etc.)
##############################################################################"
if [ $# -lt 1 ]; then
    echo "## Missing arguments:
##   1 - User private (deployment) key (i.e. URL to id_rsa)
## Optional:
##   2 - User public key for SSH access (i.e. URL to id_rsa.pub)
##############################################################################"
    exit 1
fi

PRIVATE_KEY=$1; PUBLIC_KEY=$2
DIR=$( cd "$( dirname "$0" )" && pwd )

## Go home
cd $HOME # /home/$USER

## Prepare ssh directory
if [ ! -d .ssh ]; then
    mkdir .ssh
    chmod 700 .ssh
fi

## Add known hosts
if [ ! -f .ssh/known_hosts ]; then
    touch .ssh/known_hosts
    chmod 600 .ssh/known_hosts
    ssh-keygen -R github.org
    ssh-keyscan -H github.org >> .ssh/known_hosts
    ssh-keygen -R bitbucket.org
    ssh-keyscan -H bitbucket.org >> .ssh/known_hosts
fi

## Set private key
if [ $PRIVATE_KEY ]; then
    curl -L $PRIVATE_KEY > .ssh/id_rsa
    chmod 600 .ssh/id_rsa
fi

## Set ssh agent
if [ ! -f .bash_profile ]; then
    touch .bash_profile
    cat $DIR/startagent.sh > .bash_profile
fi

## Set public key (optional)
if [ $PUBLIC_KEY ]; then
    curl -L $PUBLIC_KEY > .ssh/id_rsa.pub
    cat .ssh/id_rsa.pub > .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
fi
