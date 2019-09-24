#!/bin/bash

echo "Введите доменное имя сайта !"

read sitename

dir=/root/default

pass=$(pwgen -s -1 14)


#mkdir /var/www/$sitename &&

apt install -y dh-php php php-common php-gd php-gettext php-mcrypt php-pear php-phpseclib php-tcpdf php-xml php7.0 php7.0-cli php7.0-common php7.0-curl php7.0-dev php7.0-fpm php7.0-gd php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-readline php7.0-xml &&

apt install -y nginx &&

apt install -y mysql-server &&

apt install -y phpmyadmin &&

apt install -y exim4 &&
#################### STRICT MODE #################################
mysql -u root -p "" -e "select @@GLOBAL.sql_mode;"

touch /etc/mysql/conf.d/disable_strict_mode.cnf &&

echo "[mysqld]" > /etc/mysql/conf.d/disable_strict_mode.cnf &&

echo "sql_mode=''" >> /etc/mysql/conf.d/disable_strict_mode.cnf &&

service mysql restart &&

mysql -u root -p "" -e "select @@GLOBAL.sql_mode;" &&

echo "strict mode DISABLE" &&
################ STRICT MODE ####################################
mysql -u root -p "" -e  "create database $sitename;" &&

mysql -u root -p "" -e "CREATE USER '$sitename'@'localhost' IDENTIFIED BY '$pass';" && 

mysql -u root -p "" -e "GRANT ALL PRIVILEGES ON $sitename.* TO '$sitename'@'localhost';" && 

#dpkg-reconfigure exim4-config &&

echo "" > /etc/nginx/sites-enabled/default &&

git clone https://github.com/Korney95/default.git &&

cat $dir/default > /etc/nginx/sites-enabled/default && 

cat $dir/php.ini > /etc/php/7.0/fpm/php.ini &&

cat $dir/template.conf > /etc/php/7.0/fpm/pool.d/$sitename.conf &&

sed -i  -e "s/pochtatech.sk.ru/$sitename/g" /etc/php/7.0/fpm/pool.d/$sitename.conf &&

service php7.0-fpm restart &&

#ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin &&

nginx -t && nginx -s reload 
