#!/usr/bin/env bash


echo "#############################"
echo "###### INITIAL CONFIG #######"
echo "#############################"
# Fix for home / vagrant directory permissions
chown -R vagrant:vagrant ~vagrant/
chown -R vagrant:vagrant /vagrant
echo "Done..."