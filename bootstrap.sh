#!/usr/bin/env bash -e
#
# Sets up requirements to provision with ansible
#

########################## VARIBLES
PLAYBOOK_ZIP="playbook.zip"
PLAYBOOK_FILE="bootstrap.yml"

SOURCE_DIR=$(pwd)
DESTINATION_DIR=/tmp/bootstrap-workstation
LOGFILE=$SOURCE_DIR/bootstrap-workstation.log

GITHUB_USERNAME="luiscachog"
GITHUB_REPOSITORY_NAME="bootstrap-workstation"
GITHUB_REPOSITORY_BRANCH="devel"
#
# Clean display function
#
# usage:
#        display "My thing to output"
#
function display() {
    echo "----> $1"
}


echo "Starting log" >> $LOGFILE

echo -n "Installing pre-requisites... " >> $LOGFILE
if $(xcode-select --install 1>/dev/null 2>&1);
then
  exit $SORTIDA
fi

if [ ! $(which pip) ]
then
    sudo easy_install pip
fi
pip install --upgrade pip

SORTIDA=$?
echo OK >> $LOGFILE

echo -n "Installing Ansible... " >> $LOGFILE
pip install --upgrade ansible
SORTIDA=$?
echo OK >> $LOGFILE

echo -n "Adding key... " >> $LOGFILE
# cd ~/.ssh
# cat id_rsa.pub >> authorized_keys
# SORTIDA=$?
echo OK >> $LOGFILE

echo -n "Cleaning folders... " >> $LOGFILE
rm -rf $DESTINATION_DIR 2> /dev/null
mkdir $DESTINATION_DIR
SORTIDA=$?
echo OK >> $LOGFILE

echo -n "Downloading ZIP file... " >> $LOGFILE
curl -s -LJ https://github.com/$GITHUB_USERNAME/$GITHUB_REPOSITORY_NAME/archive/$GITHUB_REPOSITORY_BRANCH.zip -o $DESTINATION_DIR/$PLAYBOOK_ZIP
SORTIDA=$?
echo OK >> $LOGFILE

echo -n "Uncompressing repository... " >> $LOGFILE
cd $DESTINATION_DIR
unzip $PLAYBOOK_ZIP
rm $PLAYBOOK_ZIP
SORTIDA=$?
echo OK >> $LOGFILE

echo "Installing Ansible Galaxy Roles... " >> $LOGFILE
cd $DESTINATION_DIR/$GITHUB_REPOSITORY_NAME-$GITHUB_REPOSITORY_BRANCH
ansible-galaxy install -r requirements.yml
SORTIDA=$?
echo OK >> $LOGFILE

echo "Bootstraping Workstation... " >> $LOGFILE
cd $DESTINATION_DIR/$GITHUB_REPOSITORY_NAME-$GITHUB_REPOSITORY_BRANCH
ansible-playbook $PLAYBOOK_FILE -v >> $LOGFILE
SORTIDA=$?
echo OK >> $LOGFILE

# vim: ft=sh:
