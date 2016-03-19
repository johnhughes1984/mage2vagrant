# Magento 2 Vagrant

A Vagrant setup for a fully featured Magento 2 CE development environment

> Note: still in early stages, no installation instructions are currently provided, use at your own risk!

## Server details
* Ubuntu Trusty 14.04
* NGINX 1.8.1
* PHP 7.0.x
* Percona 5.6 (MySQL)
* Redis 3.0.x*
* Varnish 4.x*
* Postfix
* Xdebug (optional)
* Composer
* Magerun 2

*Installed but not configured with Magento

## Installation

### Prerequisites
* [Vagrant](https://www.vagrantup.com/)
* [Virtualbox](https://www.virtualbox.org/) or [Parallels](http://www.parallels.com/products/desktop/)
    * If using Parallels you will also need to install the [Parallels Vagrant tools](http://parallels.github.io/vagrant-parallels/docs/installation/)

### Getting started
* Ensure the above prerequisites are installed
* Clone this repository to your machine, wherever you'd like to manage your Vagrant box from
* Open the config.yaml file in your text editor of choice and ensure to set/modify the following settings in order for the installation to run without error:
    * Network Sync Type - see notes in the config.yaml file, but ensure your OS supports the sync type set
    * Network Sync Dir - this is the directory on your machine where Magento 2 will be installed and must exist (but also be empty)
    * Magento repo and Github Oauth keys - these are required in order for the composer install to run successfully
* Open the repositories directory within the terminal / command line and run `vagrant up` to begin installation
    * If using Parallels, unless it has been set as your default provider you will need to append `--provider=parallels` to the above command
* Map the IP address to the Magento base url you have set in config.yaml on your machines host file
* Once the installation has completed visit enter the base url into your browser to view your Magento 2 site (if you chose to skip the CLI install ensure to add /setup to the domain to proceed with the standard Magento 2 install wizard)

## What does this do?
* Installs and configures the above server environment and tools
* Downloads the latest version of Magento 2 via composer and (optionally) installs via CLI
* Server and Magento install configuration can be tailored using the config.yaml file
    * This allows for control over the following and more:
        * VM settings
        * Magento install settings (e.g. base url, db settings, locale, admin user)
        * Sample data install
        * Run mode (e.g. developer/production)
* Also adds 'pretty' bash terminal prompt with support for current git branch and handy shortcuts

## Todo / Wishlist
* Add detailed install instructions
* Move service installs into base boxes (e.g. base box with nginx etc. preinstalled) to speed up install and reduce complexity / likelihood of setup issues
* Add support for installing multiple sites (and adding new vhosts once provisioned via scripts)
* Add support for more boxes
* Redis and Varnish configuration
* Add SSL support
* Better documentation
* Add validation for yaml config settings (e.g. auth keys)
* Tidy up / improve yaml config (maybe split some out into separate files)
* Add support for other technologies and make configurable (e.g. Centos, PHP version, HHVM, Apache, Memcahced, standard MySQL)
* Install further useful development tools (e.g. PHPUnit Node.js, NPM, Grunt, Gulp etc.)
* Magento EE version (plus services e.g. RabbitMQ / Solr / Elastic Search)
* Docker version?

## Mentions
Thanks to the following for inspiration / use of code:

* Steve Robbins: https://github.com/steverobbins/Vagrant2
* Ryan Street: https://github.com/ryanstreet/magento2-vagrant
* Piotr Kuczynski: https://gist.github.com/pkuczynski/8665367
* PuPHPet: https://puphpet.com/