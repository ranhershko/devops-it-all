#!/bin/bash -x

sudo yum update -y
sudo dnf -y install python2
sudo dnf -y install python2-pip
sudo dnf -y install python3
sudo dnf -y install python3-pip
sudo dnf -y install jq
sudo -H pip3 install ansible
sudo -H pip3 install dnsmasq
