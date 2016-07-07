#!/usr/bin/env bash

projectdir=$1


echo "#############################"
echo "######## CRON SETUP #########"
echo "#############################"
(crontab -u vagrant -l 2>/dev/null; echo "* * * * * /usr/bin/php -c /etc/php/7.0/cli/php.ini $projectdir/bin/magento cron:run | grep -v "Ran jobs by schedule" >> $projectdir/var/log/magento.cron.log") | crontab -u vagrant -
(crontab -u vagrant -l 2>/dev/null; echo "* * * * * /usr/bin/php -c /etc/php/7.0/fpm/php.ini $projectdir/update/cron.php >> $projectdir/var/log/update.cron.log") | crontab -u vagrant -
(crontab -u vagrant -l 2>/dev/null; echo "* * * * * /usr/bin/php -c /etc/php/7.0/fpm/php.ini $projectdir/bin/magento setup:cron:run >> $projectdir/var/log/setup.cron.log") | crontab -u vagrant -
echo "Done..."