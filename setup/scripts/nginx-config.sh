#!/usr/bin/env bash

base_url=$1
mage_mode=$2


echo "#############################"
echo "######## NGINX SETUP ########"
echo "#############################"
# Copy example vhost file to sites-available
cp /vagrant/setup/nginx/example.conf /etc/nginx/sites-available/$base_url
# Replace vhost placeholders with config varaibles
sed -i "s,{vhost},$base_url,g" /etc/nginx/sites-available/$base_url
sed -i "s,{mage_mode},$mage_mode,g" /etc/nginx/sites-available/$base_url
# Add vhost to enabled sites
ln -fs /etc/nginx/sites-available/$base_url /etc/nginx/sites-enabled/
service nginx restart
echo "Done..."