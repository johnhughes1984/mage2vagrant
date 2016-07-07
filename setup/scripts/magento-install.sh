#!/usr/bin/env bash

magento_install_admin_firstname=$1
magento_install_admin_lastname=$2
magento_install_admin_email=$3
magento_install_admin_user=$4
magento_install_admin_password=$5
magento_setup_base_url=$6
magento_install_backend_frontname=$7
magento_install_language=$8
magento_install_currency=$9
magento_install_timezone=${10}
magento_install_session_save=${11}
magento_install_use_rewrites=${12}
magento_install_default_country=${13}
magento_install_admin_session_lifetime=${14}
mage_mode=${15}


echo "#############################"
echo "###### MAGENTO INSTALL ######"
echo "#############################"
cd /var/www/$magento_setup_base_url
./bin/magento setup:install \
--admin-firstname="$magento_install_admin_firstname" \
--admin-lastname="$magento_install_admin_lastname" \
--admin-email="$magento_install_admin_email" \
--admin-user="$magento_install_admin_user" \
--admin-password="$magento_install_admin_password" \
--base-url="http://$magento_setup_base_url/" \
--backend-frontname="$magento_install_backend_frontname" \
--db-host="localhost" \
--db-name="magento" \
--db-user="magento" \
--db-password="magento123" \
--language="$magento_install_language" \
--currency="$magento_install_currency" \
--timezone="$magento_install_timezone" \
--session-save="$magento_install_session_save" \
--use-rewrites="$magento_install_use_rewrites"
# Set default country
n98-magerun2.phar config:set general/country/default $magento_install_default_country
# Set admin session timeou)
n98-magerun2.phar config:set admin/security/session_lifetime $magento_install_admin_session_lifetime
# Set mode
./bin/magento deploy:mode:set $mage_mode
echo "Done..."
