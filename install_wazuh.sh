#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install curl apt-transport-https unzip wget libcap2-bin software-properties-common lsb-release gnupg -y

curl -so ~/unattended-installation.sh https://packages.wazuh.com/resources/4.2/open-distro/unattended-installation/unattended-installation.sh && bash ~/unattended-installation.sh