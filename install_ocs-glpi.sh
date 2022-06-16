#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install vim apache2 mariadb-server php libapache2-mod-perl2 libxml-simple-perl libnet-ip-perl libsoap-lite-perl libapache2-mod-perl2-dev make php-mysql php-gd php-mbstring php-soap php-xml php-curl -y

printf "\n" | sudo perl -MCPAN -e "install XML::Entities"
sudo cpan Apache2::SOAP
sudo cpan SOAP::Lite
sudo cpan Mojolicious::Lite
sudo cpan Switch

wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/2.9.2/OCSNG_UNIX_SERVER-2.9.2.tar.gz
tar -zxvf OCSNG_UNIX_SERVER-2.9.2.tar.gz
cd OCSNG_UNIX_SERVER-2.9.2/
printf "\n\n\n\n\n\n\n/etc/apache2/conf-enabled\n\n\n\n\n\ny\n\ny\n\n\n\n\n\n\n" | sudo ./setup.sh
cd

printf "create database ocsweb;\nGRANT ALL PRIVILEGES ON *.* TO ocs@'localhost' IDENTIFIED BY 'ocs';\nFLUSH PRIVILEGES;\nexit\n" | sudo mysql -u root

sudo service mariadb restart
sudo service apache2 restart

read -p "Allez sur http://IP/ocsreports pour configurer OCS et faites Entrée pour continuer l'installation :3"
read -p "MySQL login: ocs"
read -p "MYSQL password: ocs"
read -p "Name of Database: ocsweb"
read -p "MySQL HostName: localhost"
read -p "Send"
read -p "Click here to enter OCS-NG GUI"
read -p "Perform the update"
read -p "Click here to enter OCS-NG GUI"
read -p "User : admin | Password : admin"

sudo rm /usr/share/ocsinventory-reports/ocsreports/install.php

printf "GRANT ALL PRIVILEGES ON ocsweb.* TO 'ocs'@'localhost' IDENTIFIED BY 'ocssecret' WITH GRANT OPTION;\nFLUSH PRIVILEGES;\nexit\n" | sudo mysql -u root

sudo sed -i 's/PerlSetVar OCS_DB_PWD ocs/PerlSetVar OCS_DB_PWD ocssecret/' /etc/apache2/conf-enabled/z-ocsinventory-server.conf
sudo sed -i '/PSWD_BASE/s/ocs/ocssecret/' /usr/share/ocsinventory-reports/ocsreports/dbconfig.inc.php

sudo service mariadb restart
sudo service apache2 restart

sudo apt install ocsinventory-agent -y
sudo ocsinventory-agent

printf "create database dbglpi;\nGRANT ALL PRIVILEGES ON dbglpi.* TO glpiuser IDENTIFIED BY 'password';\nFLUSH PRIVILEGES;\nexit\n" | sudo mysql -u root

wget https://github.com/glpi-project/glpi/releases/download/9.5.7/glpi-9.5.7.tgz
sudo tar -zxvf glpi-9.5.7.tgz -C /var/www/html/
sudo chown -R www-data /var/www/html/glpi
sudo apt install php-intl php-ldap php-apcu php-imap php-xmlrpc php-cas php-zip php-bz2 -y
sudo a2enmod rewrite
sudo sed -i '13 i \\t<Directory /var/www/html/glpi>' /etc/apache2/sites-available/000-default.conf
sudo sed -i '14 i \\tOptions Indexes FollowSymLinks' /etc/apache2/sites-available/000-default.conf
sudo sed -i '15 i \\tAllowOverride All' /etc/apache2/sites-available/000-default.conf
sudo sed -i '16 i \\tRequire all granted' /etc/apache2/sites-available/000-default.conf
sudo sed -i '17 i \\t</Directory>' /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart

read -p "Allez sur http://IP/glpi pour configurer GLPI et faites Entrée pour continuer l'installation :3"
read -p "Français"
read -p "OK"
read -p "J'ai lu et ACCEPTE les termes de la licence énoncés ci-dessus."
read -p "Continuer"
read -p "Installer"
read -p "Continuer"
read -p "Serveur SQL (MariaDB ou MySQL): localhost"
read -p "Utilisateur SQL: glpiuser"
read -p "Mot de passe SQL: password"
read -p "dbglpi"
read -p "Identifiant: glpi"
read -p "Mot de passe: glpi"
read -p "Changez les mots de passe des 4 utilisateurs par défaut"
sudo rm /var/www/html/glpi/install/install.php

wget https://github.com/pluginsGLPI/ocsinventoryng/releases/download/1.7.3/glpi-ocsinventoryng-1.7.3.tar.gz
sudo tar -zxvf glpi-ocsinventoryng-1.7.3.tar.gz -C /var/www/html/glpi/plugins/
read -p "Interface Web GLPI : Configuration -> Plugins -> Installer OCS Inventory NG -> Activer le plugin"
read -p "Interface Web GLPI : Outils -> OCS Inventory NG -> Ajouter un serveur OCSNG"
read -p "Nom: OCS NG"
read -p "Hôte: localhost"
read -p "Base de données: ocsweb"
read -p "Utilisateur: ocs"
read -p "Mot de passe: ocssecret"

read -p "Interface Web OCS : Configuration -> Configuration générale -> Serveur -> TRACE_DELETED (ON)"
read -p "Interface Web GLPI : Outils -> OCS Inventory NG -> Import de l'inventaire -> Importation de nouveaux ordinateurs -> Importer"

read -p "Interface Web GLPI : Configuration -> Authentification -> Annuaires LDAP -> +"
read -p "Préconfiguration: Active Directory"
read -p "Nom: LiaisonLDAP"
read -p "Serveur par défaut: Oui"
read -p "Serveur: 172.20.0.10"
read -p "BaseDN: DC=stadiumcompany,DC=com"
read -p "DN du compte: CN=Administrateur,CN=Users,DC=stadiumcompany,DC=com"
read -p "Mot de passe du compte: MOT_DE_PASSE_AD"
read -p "Actif: Oui"
read -p "+ Ajouter"
read -p "Interface Web GLPI : Administration -> Utilisateurs -> Liaison annuaire LDAP -> Importation de nouveaux utilisateurs -> Rechercher -> Ajouter/Importer"

echo "Bye :3"
