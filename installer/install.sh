debconf-set-selections ${PWD}/debconf.selections

apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends apt-utils
apt-get install -y zip unzip
apt-get install -y \
        php7.0 \
        php7.0-mysql
apt-get install apache2 libapache2-mod-php7.0 -y
apt-get install mariadb-common mariadb-server mariadb-client -y
apt-get install phpmyadmin -y
apt-get install git nano curl ftp wget -y

# install Grafana
wget -O /tmp/grafana.deb https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_5.2.4_amd64.deb
apt-get install -y adduser libfontconfig
dpkg -i /tmp/grafana.deb

git clone https://github.com/Zerto-TA-Public/zplanner.git
a2enmod rewrite
/bin/sed -i "s/\;date\.timezone\ \=/date\.timezone\ \=\ ${DATE_TIMEZONE}/" /etc/php/7.0/apache2/php.ini


echo "group_concat_max_len = 1000000000" >> /etc/mysql/mariadb.conf.d/50-server.cnf
rm -r /var/www/html/
chown -R www-data:www-data $HOME/zplanner/html
ln -s $HOME/zplanner/html /var/www/html
cp /tmp/php.ini /etc/php/7.0/apache2/php.ini
mkdir -p /usr/share/grafana/data/
