#!/usr/bin/env bash -e
#
# Sets up requirements to provision with ansible
#

#
# Clean display function
#
# usage:
#        display "My thing to output"
#
function display() {
    echo "----> $1"
}

if $(xcode-select --install 1>/dev/null 2>&1);
then
  exit 1
fi

if [ ! $(which pip) ]
then
    sudo easy_install pip
fi

pip install --upgrade pip

echo "Installing Ansible"
pip install --upgrade ansible

ansible-playbook bootstrap.yml -v

# vim: ft=sh:
