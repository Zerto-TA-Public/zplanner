#!/bin/bash

# install Grafana
wget -O /tmp/grafana.deb https://dl.grafana.com/oss/release/grafana_5.4.2_amd64.deb
sudo dpkg -i /tmp/grafana.deb

sudo a2enmod rewrite
sudo /bin/sed -i "s/\;date\.timezone\ \=/date\.timezone\ \=\ ${DATE_TIMEZONE}/" /etc/php/7.0/apache2/php.ini


sudo bash -c "echo 'group_concat_max_len = 1000000000' >> /etc/mysql/mariadb.conf.d/50-server.cnf"
sudo rm -r /var/www/html/
sudo /etc/init.d/mysql stop
sudo tar -xf ${PWD}/mysql.tar.gz -C /var/lib/
sudo tar -xf ${PWD}/phpmyadmin.tar.gz -C 
sudo /etc/etc/init.d/mysql start
sudo chown -R www-data:www-data $HOME/zplanner/html
sudo ln -s $HOME/zplanner/html /var/www/html
sudo cp ${PWD}/php.ini /etc/php/7.0/apache2/php.ini
sudo cp ${PWD}/grafana.db /usr/share/grafana/data/grafana.db
sudo mkdir -p /usr/share/grafana/data/

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo service apache2 restart