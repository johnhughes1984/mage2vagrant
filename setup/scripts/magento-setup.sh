#!/usr/bin/env bash

base_url=$1
install_sample_data=$2


echo "#############################"
echo "##### MAGENTO DOWNLOAD ######"
echo "#############################"
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/$base_url/
# Copy composer auth keys to Magento project dir (for future composer updates, inc. sample data)
cp ~vagrant/.composer/auth.json /var/www/$base_url/
cd /var/www/$base_url
# Ensure bin/magento is executable
chmod +x ./bin/magento
echo "Done..."


if [ "$install_sample_data" == "y" ]; then
    echo "#############################"
    echo "#### SAMPLE DATA INSTALL ####"
    echo "#############################"
    ./bin/magento sampledata:deploy
    echo "Done..."
fi


echo "##############################"
echo "#### SET FILE PERMISSIONS ####"
echo "##############################"
find . -type d -exec chmod 770 {} \;
find . -type f -exec chmod 660 {} \;
chmod +x ./bin/magento
echo "Done..."