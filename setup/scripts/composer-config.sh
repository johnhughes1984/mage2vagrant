#!/usr/bin/env bash

magento_auth_username=$1
magento_auth_password=$2
github_oauth=$3


echo "#############################"
echo "###### COMPOSER CONFIG ######"
echo "#############################"
# Add Magento & Github auth keys for vagrant user (saves to ~/.config/composer/auth.json)
composer config -g http-basic.repo.magento.com $magento_auth_username $magento_auth_password
composer config -g github-oauth.github.com $github_oauth
echo "Done..."