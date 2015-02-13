#!/bin/bash
NEW_USER=$1; GROUP=${2:-svven}
echo "
##############################################################################
## Add user ($NEW_USER) to group ($GROUP)
## User: $USER (e.g. root, vagrant, ubuntu)
##############################################################################"
if [ $# -lt 1 ]; then
    echo "## Missing arguments:
##   1 - User to be added (e.g.: svven, ducu, jon etc.)
## Optional:
##   2 - Group name, default: svven
##############################################################################
"
    exit 1
fi

egrep -i "^$NEW_USER:" /etc/passwd
if [ $? -eq 0 ]; then
    echo "User already exists: $NEW_USER"
    exit 0
fi

## Create specified user, and make it sudo
## http://brianflove.com/2013/06/18/add-new-sudo-user-to-ec2-ubuntu/
sudo adduser --quiet --gecos "" --ingroup sudo --disabled-password $NEW_USER
echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$NEW_USER

## Add user to specified group
egrep -i "^$GROUP:" /etc/group
if [ $? -ne 0 ]; then
    sudo addgroup $GROUP
fi
sudo adduser $NEW_USER $GROUP

# sudo deluser --remove-home $NEW_USER
# sudo deluser $NEW_USER sudo # remove from sudo group in the end
