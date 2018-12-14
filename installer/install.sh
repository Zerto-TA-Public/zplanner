sudo debconf-set-selections ${PWD}/debconf.selections

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y php7.0 php7.0-mysql
sudo apt-get install apache2 libapache2-mod-php7.0 -y
sudo apt-get install mariadb-common mariadb-server mariadb-client -y
sudo apt-get install phpmyadmin -y

# install Grafana
wget -O /tmp/grafana.deb https://dl.grafana.com/oss/release/grafana_5.4.2_amd64.deb
sudo dpkg -i /tmp/grafana.deb

sudo a2enmod rewrite
sudo /bin/sed -i "s/\;date\.timezone\ \=/date\.timezone\ \=\ ${DATE_TIMEZONE}/" /etc/php/7.0/apache2/php.ini


sudo echo "group_concat_max_len = 1000000000" >> /etc/mysql/mariadb.conf.d/50-server.cnf
sudo rm -r /var/www/html/
sudo chown -R www-data:www-data $HOME/zplanner/html
sudo ln -s $HOME/zplanner/html /var/www/html
sudo cp /tmp/php.ini /etc/php/7.0/apache2/php.ini
sudo mkdir -p /usr/share/grafana/data/
