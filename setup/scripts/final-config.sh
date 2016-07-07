#!/usr/bin/env bash

base_dir=$1
ip_address=$2
base_url=$3


echo "#############################"
echo "###### .BASHRC CONFIG #######"
echo "#############################"
# Set public_html as login dir
echo "
# Goto public_html dir at login
cd $base_dir" >> /home/vagrant/.bashrc
echo "Done..."

echo "Setup complete. Please add '$ip_address $base_url' to your hosts file."
echo "This file is normally /etc/hosts on Mac OS X and Linux and %SystemRoot%\System32\drivers\etc\hosts on Windows."
echo "Note: you will need sudo / administrator access to edit / save this file"