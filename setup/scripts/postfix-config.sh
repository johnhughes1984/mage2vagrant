#!/usr/bin/env bash

base_url=$1


echo "#############################"
echo "### SET POSTFIX MAILNAME ####"
echo "#############################"
postconf -e "myhostname = $base_url"
postconf -e "mydestination = $base_url localhost.localdomain, localhost"
echo $base_url > /etc/mailname
echo "Done..."