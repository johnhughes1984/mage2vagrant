# Magento 2 Vagrant Dev

A Vagrant setup for a fully featured Magento 2 CE development environment

> Note: still in early stages, only basic installation instructions are provided. This has only been tested on Mac OS X

## Server details
* https://atlas.hashicorp.com/fisheyehq/boxes/mage2-ubuntu-16.04-php7.0
* Ubuntu Xenial 16.04
* NGINX
* Percona (MySQL)
* PHP 7.0
* Composer
* Xdebug
* Magerun 2

## Installation 

### Prerequisites
* Install [Virtualbox](https://www.virtualbox.org) (v5.x)
* Install [Vagrant](https://www.vagrantup.com/docs/installation/) (v1.8.4+)
> IMPORTANT: this will NOT work with any version of Vagrant lower than the version mentioned above due to incompatible changes in Ubuntu Xenial
* Install tools to manage SSH (Windows only)
	* e.g. [Git Bash](https://git-for-windows.github.io), [Cygwin](https://www.cygwin.com) or [PuTTY and PuTTYGen](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)

### Configuration
* Clone this repository to your machine, wherever you'd like to manage your Vagrant box / Magento 2 codebase from
* Copy [setup/config.yaml.sample](setup/config.yaml.sample) to `setup/config.yaml` and open in a text editor
* Add Magento repo and Github Oauth keys (these are required in order for the composer install to run successfully)
	* http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html
	* https://help.github.com/articles/creating-an-access-token-for-command-line-use/
* Change any further settings as desired

### Provision
* Run `vagrant up` to provision your machine (be patient as the composer install takes some time, especially when sample data is included) then follow the instructions in your terminal for updating your host file once complete

## What does this do?
* Installs and configures the above server environment and tools
* Downloads the latest version of Magento 2 via composer and installs via CLI based on config
* Server and Magento install configuration can be tailored using the config.yaml file
    * This allows for control over the following and more:
        * VM settings
        * Magento install settings (e.g. base url, locale, admin user etc.)
        * Sample data install
        * Run mode (e.g. developer/production)
* Cron setup as per http://devdocs.magento.com/guides/v2.0/config-guide/cli/config-cli-subcommands-cron.html
* Postfix setup for email support
* Also adds 'pretty' bash terminal prompt with support for current git branch and handy shortcuts

## TODO / Wishlist
* Add detailed install instructions
* Add support for more providers (Parallels, VMWare etc.)
* Redis and Varnish configuration
* Add SSL support
* Better documentation
* Better validation for yaml config settings
* Tidy up / improve yaml config (maybe split some out into separate files)
* Add support for other technologies and make configurable (e.g. Centos, PHP version, HHVM, Apache, Memcahced, standard MySQL)
* Install further useful development tools
* Magento EE version (plus services e.g. RabbitMQ / Solr / Elastic Search)
* Docker version?

## Mentions
Thanks to the following for inspiration:

* Steve Robbins: https://github.com/steverobbins/Vagrant2
* Ryan Street: https://github.com/ryanstreet/magento2-vagrant
* PuPHPet: https://puphpet.com/