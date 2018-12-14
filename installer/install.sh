#!/bin/bash
sudo debconf-set-selections ${PWD}/debconf.selections

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y php7.0 php7.0-mysql
sudo apt-get install apache2 libapache2-mod-php7.0 -y
sudo apt-get install mariadb-common mariadb-server mariadb-client -y
sudo apt-get install phpmyadmin -y