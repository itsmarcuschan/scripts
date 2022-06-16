#!/bin/bash

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

sudo apt purge netplan.io -y

sudo apt install vim net-tools ifupdown resolvconf dnsutils netcat-traditional libidn11-dev libgmp10 sysstat sqlite3 libaio1 unzip pax neofetch -y

echo "zimbra.stadiumcompany.com" | sudo tee /etc/hostname

echo -e "172.20.0.13\tzimbra.stadiumcompany.com\tzimbra" | sudo tee /etc/hosts

echo -e "nameserver\t172.20.0.10\nnameserver\t172.20.0.11\nnameserver\t1.1.1.1\nsearch\tstadiumcompany.com" | sudo tee -a /etc/resolvconf/resolv.conf.d/head

echo "neofetch" >> .bashrc

sudo reboot

sudo resolvconf --enable-updates
sudo resolvconf -u

nslookup zimbra.stadiumcompany.com

sudo service apparmor stop
sudo update-rc.d -f apparmor remove
sudo apt purge apparmor* -y

#wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz
wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz

#tar -zxvf zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz
tar -zxvf zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz

#cd zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220/
cd zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954/

printf "Y\n\n\n\n\nN\n\n\n\n\n\nN\n\n\n\nY\n6\n4\nBts2022\nr\na\n\n\nY\nN\n\n" | sudo ./install.sh

sudo reboot