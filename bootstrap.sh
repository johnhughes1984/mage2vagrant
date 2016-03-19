#!/usr/bin/env bash


echo "#############################"
echo "##### PARSE YAML CONFIG #####"
echo "#############################"
# Include parse_yaml function
. /vagrant/parse_yaml.sh
# Read YAML config file and assign to variables
eval $(parse_yaml /vagrant/config.yaml)


echo "#############################"
echo "#### SET DEBCONF VALUES #####"
echo "#############################"
# Set postfix config
debconf-set-selections <<< "postfix postfix/mailname string $vagrant_config_vm_hostname"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
# Set DB root password, override vm root password if root user being used for magento db
if [ "$magento_setup_db_user" == "root" ]; then
    magento_setup_db_password=$vagrant_config_db_root_password
fi
debconf-set-selections <<< "percona-server-server-5.6 percona-server-server/root_password password $vagrant_config_db_root_password"
debconf-set-selections <<< "percona-server-server-5.6 percona-server-server/root_password_again password $vagrant_config_db_root_password"
echo "Done..."


echo "#############################"
echo "##### UPDATE PACKAGES #######"
echo "#############################"
apt-get -y update
echo "Done..."


echo "#############################"
echo "### ADD THIRD PARTY REPOS ###"
echo "#############################"
apt-get install -y software-properties-common
apt-get install -y python-software-properties
# NGINX
add-apt-repository -y ppa:nginx/stable
# PHP 7.0
add-apt-repository -y ppa:ondrej/php
# Percona
wget https://repo.percona.com/apt/percona-release_0.1-3.$(lsb_release -sc)_all.deb
dpkg -i percona-release_0.1-3.$(lsb_release -sc)_all.deb
apt-get -y update
# Redis 3.x
add-apt-repository -y ppa:chris-lea/redis-server
# Varnish
add-apt-repository -y "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.1"
echo "Done..."


echo "#############################"
echo "##### INSTALL PACKAGES ######"
echo "#############################"
apt-get -y update
apt-get -y install \
  vim \
  git \
  htop \
  zip \
  unzip \
  curl \
  postfix \
  nginx \
  php7.0-fpm \
  php7.0-cli \
  php7.0-bcmath \
  php7.0-curl \
  php7.0-dev \
  php7.0-gd \
  php7.0-intl \
  php7.0-mbstring\
  php7.0-mcrypt \
  php7.0-mysql \
  php7.0-soap \
  php7.0-xml \
  php7.0-zip \
  percona-server-server-5.6 \
  percona-server-common-5.6 \
  percona-server-client-5.6 \
  redis-server \
  redis-tools
# Varnish package repo cannot be authenticated so force install
apt-get -y --force-yes install varnish
echo "Done..."


echo "#############################"
echo "######## NGINX SETUP ########"
echo "#############################"
# Replace www-data user with vagrant
perl -pi -e "s/www-data/vagrant/g" /etc/nginx/nginx.conf
# Add magento rewrites conf file
mkdir /etc/nginx/magento
# Add Magento nginx conf file
cp /vagrant/setup/nginx/rewrites.conf /etc/nginx/magento/
# Copy example vhost file to sites-available
cp /vagrant/setup/nginx/vhost-example.conf /etc/nginx/sites-available/
# Copy again for actual vhost
cp /etc/nginx/sites-available/vhost-example.conf /etc/nginx/sites-available/$magento_setup_base_url
# Replace vhost placeholders with config varaible
perl -pi -e "s/{vhost}/$magento_setup_base_url/g" /etc/nginx/sites-available/$magento_setup_base_url
perl -pi -e "s/{vhostslug}/${magento_setup_base_url/./}/g" /etc/nginx/sites-available/$magento_setup_base_url
perl -pi -e "s/{mage_mode}/$magento_setup_mode/g" /etc/nginx/sites-available/$magento_setup_base_url

# Add vhost to enabled sites list
ln -fs /etc/nginx/sites-available/$magento_setup_base_url /etc/nginx/sites-enabled/
echo "Done..."


echo "#############################"
echo "######### PHP SETUP #########"
echo "#############################"
# Replace www-data user with vagrant
perl -pi -e "s/www-data/vagrant/g" /etc/php/7.0/fpm/pool.d/www.conf
echo "date.timezone = Europe/London" >> /etc/php/7.0/fpm/php.ini
echo "date.timezone = Europe/London" >> /etc/php/7.0/cli/php.ini
echo "Done..."


echo "#############################"
echo "###### INSTALL XDEBUG #######"
echo "#############################"
wget http://xdebug.org/files/xdebug-2.4.0rc2.tgz
tar -xzf xdebug-2.4.0rc2.tgz
cd xdebug-2.4.0RC2/
phpize
./configure --enable-xdebug
make
cp modules/xdebug.so /usr/lib/.
# For FPM
echo 'zend_extension="/usr/lib/xdebug.so"' > /etc/php/7.0/fpm/conf.d/20-xdebug.ini
echo "xdebug.remote_enable=1" >> /etc/php/7.0/fpm/conf.d/20-xdebug.ini
# For CLI
echo 'zend_extension="/usr/lib/xdebug.so"' > /etc/php/7.0/cli/conf.d/20-xdebug.ini
echo "xdebug.remote_enable=1" >> /etc/php/7.0/cli/conf.d/20-xdebug.ini
echo "Done..."


echo "#############################"
echo "##### INSTALL COMPOSER ######"
echo "#############################"
curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer
# Add Magento & Github auth keys for vagrant user
mkdir -p /home/vagrant/.config/composer/
cp /vagrant/setup/composer/auth.json /home/vagrant/.config/composer/
# Replace placeholders with config variables
perl -pi -e "s/{magentousername}/$magento_auth_magentousername/g" /home/vagrant/.config/composer/auth.json
perl -pi -e "s/{magentopassword}/$magento_auth_magentopassword/g" /home/vagrant/.config/composer/auth.json
perl -pi -e "s/{githuboauth}/$magento_auth_githuboauth/g" /home/vagrant/.config/composer/auth.json
# Also add globally as root whilst running this script
composer config -g http-basic.repo.magento.com $magento_auth_magentousername $magento_auth_magentopassword
composer config -g github-oauth.github.com $magento_auth_githuboauth
echo "Done..."


echo "#############################"
echo "### INSTALL N98-MAGERUN2 ####"
echo "#############################"
curl -O https://files.magerun.net/n98-magerun2.phar
chmod +x ./n98-magerun2.phar
cp ./n98-magerun2.phar /usr/local/bin/
echo "Done..."


echo "#############################"
echo "######## MYSQL SETUP ########"
echo "#############################"
# Store root credentials
echo "[client]
user=root
password=$vagrant_config_db_root_password" > ~/.my.cnf
if [ "$magento_setup_db_host" == "localhost" ]; then
    # Basic MySQL config
    echo "max_allowed_packet=256M" >> /etc/mysql/my.cnf
    # Create database
    mysql -e "CREATE DATABASE $magento_setup_db_name;"
    # Create user if not root and grant privileges to access from anywhere
    if [ "$magento_setup_db_user" != "root" ]; then
        mysql -e "CREATE USER '$magento_setup_db_user'@'%' IDENTIFIED BY '$magento_setup_db_password';"
        mysql -e "GRANT ALL PRIVILEGES ON $magento_setup_db_name.* TO '$magento_setup_db_user'@'$magento_setup_db_host' IDENTIFIED BY '$magento_setup_db_password';
        FLUSH PRIVILEGES;"
    fi
fi
# Store magento db user credentials
echo "[client]
database=$magento_setup_db_name
user=$magento_setup_db_user
password=$magento_setup_db_password
host=$magento_setup_db_host" > ~vagrant/.my.cnf
echo "Done..."


echo "#############################"
echo "##### MAGENTO DOWNLOAD ######"
echo "#############################"
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/$magento_setup_base_url/
# Copy composer auth keys to Magento project var dir (for further composer updates)
mkdir -p /var/www/$magento_setup_base_url/var/composer_home/
cp /home/vagrant/.config/composer/auth.json /var/www/$magento_setup_base_url/var/composer_home/
cd /var/www/$magento_setup_base_url
# Ensure bin/magento is executable
chmod +x ./bin/magento
echo "Done..."


if [ "$magento_setup_sampledata" == "y" ]; then
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

if [ "$magento_setup_cli_install" == "y" ]; then
echo "#############################"
echo "###### MAGENTO INSTALL ######"
echo "#############################"
    ./bin/magento setup:install \
    --admin-firstname="$magento_install_admin_firstname" \
     --admin-lastname="$magento_install_admin_lastname" \
     --admin-email="$magento_install_admin_email" \
     --admin-user="$magento_install_admin_user" \
     --admin-password="$magento_install_admin_password" \
     --base-url="http://$magento_setup_base_url/" \
     --backend-frontname="$magento_install_backend_frontname" \
     --db-host="$magento_setup_db_host" \
     --db-name="$magento_setup_db_name" \
     --db-user="$magento_setup_db_user" \
     --db-password="$magento_setup_db_password" \
     --language="$magento_install_language" \
     --currency="$magento_install_currency" \
     --timezone="$magento_install_timezone" \
     --session-save="$magento_install_session_save" \
     --use-rewrites="$magento_install_use_rewrites"
    # Set default country
    n98-magerun2.phar config:set general/country/default $magento_install_default_country
    # Set admin session timeou)
    n98-magerun2.phar config:set admin/security/session_lifetime $magento_install_admin_session_lifetime
    echo "Done..."
fi

echo "#############################"
echo "##### ADD .BASHRC FILE ######"
echo "#############################"
cp /vagrant/setup/.bashrc /home/vagrant/
echo "Done..."


echo "#############################"
echo "###### START SERVICES #######"
echo "#############################"
service nginx restart
service php7.0-fpm restart
service mysql restart
redis-server /etc/redis/redis.conf
echo "redis-server /etc/redis/redis.conf" > /etc/rc.local
echo "Done..."