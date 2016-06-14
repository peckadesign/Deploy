#!/usr/bin/env bash

echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list
wget https://www.dotdeb.org/dotdeb.gpg -qO- | apt-key add -

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -

apt-get update

apt-get upgrade -y --force-yes
apt-get install -y --force-yes \
	git \
	htop \
	apache2 \
	php \
	libapache2-mod-php7.0 \
	php70-curl \
	nodejs

a2enmod rewrite

php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

npm install -g grunt

if ! [ -L "/var/www" ]; then
	rm -rf "/var/www"
	ln -fs "/vagrant" "/var/www"
fi

rm -rf /etc/apache2/sites-enabled/*
if ! [ -L "/etc/apache2/sites-available" ]; then
	if ! [ -L "/etc/apache2/sites-available/deploy.conf" ]; then
		ln -s "/vagrant/vagrant/server/apache/sites-available/deploy.conf" "/etc/apache2/sites-available/deploy.conf"
	fi
	a2ensite -q deploy.conf
fi

if ! [ -L "/etc/apache2/conf-available/deploy.conf" ]; then
	rm -f "/etc/apache2/conf-available/deploy.conf"
	ln -s "/vagrant/vagrant/server/apache/conf-available/deploy.conf" "/etc/apache2/conf-available/deploy.conf"
fi
a2enconf -q deploy.conf

if ! [ -L "/etc/php/7.0/cli/conf.d/deploy.ini" ]; then
	rm -f "/etc/php/7.0/cli/conf.d/deploy.ini"
	ln -s "/vagrant/vagrant/server/php/cli.ini" "/etc/php/7.0/cli/conf.d/deploy.ini"
fi

if ! [ -L "/etc/php/7.0/apache2/conf.d/deploy.ini" ]; then
	rm -f "/etc/php/7.0/apache2/conf.d/deploy.ini"
	ln -s "/vagrant/vagrant/server/php/apache2.ini" "/etc/php/7.0/apache2/conf.d/deploy.ini"
fi

if [ -f "/etc/php/7.0/mods-available/xdebug.ini" ]; then
	rm -f "/etc/php/7.0/mods-available/xdebug.ini"
	touch "/etc/php/7.0/mods-available/xdebug.ini"
fi

chmod -R 0777 "/vagrant/temp" "/vagrant/log"
