#!/bin/bash

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

sudo apt purge netplan.io -y

sudo apt install vim ifupdown resolvconf dnsutils net-tools neofetch -y

echo "nagios.stadiumcompany.com" | sudo tee /etc/hostname

echo -e "172.20.0.14\tnagios.stadiumcompany.com\tnagios" | sudo tee /etc/hosts

echo -e "nameserver\t172.20.0.10\nnameserver\t172.20.0.11\nnameserver\t1.1.1.1\nsearch\tstadiumcompany.com" | sudo tee -a /etc/resolvconf/resolv.conf.d/head

echo "neofetch" >> .bashrc

sudo reboot

sudo resolvconf --enable-updates
sudo resolvconf -u

nslookup nagios.stadiumcompany.com

#sudo apt install autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.2 libgd-dev -y
sudo apt install autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.4 libgd-dev -y

wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar -zxf nagioscore.tar.gz -C /tmp/

cd /tmp/nagioscore-nagios-4.4.6/
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all

sudo make install-groups-users
sudo usermod -a -G nagios www-data

sudo make install

sudo make install-daemoninit

sudo make install-commandmode

sudo make install-config

sudo make install-webconf
sudo a2enmod rewrite
sudo a2enmod cgi

sudo ufw allow Apache
sudo ufw reload

sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

sudo systemctl restart apache2.service
sudo systemctl start nagios.service
cd

sudo apt install autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext -y

wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz
tar -zxf nagios-plugins.tar.gz -C /tmp/
cd /tmp/nagios-plugins-release-2.3.3/
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install
cd

sudo systemctl start nagios.service
sudo systemctl stop nagios.service
sudo systemctl restart nagios.service
sudo systemctl status nagios.service