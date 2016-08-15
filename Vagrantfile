# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
current_dir = File.dirname(File.expand_path(__FILE__))
config_file = YAML.load_file("#{current_dir}/setup/config.yaml")

# Config file validation
config_file.each do |section_key,section_value|
    section_value.each do |key,value|
        if value.nil? || value == 0
           puts "#{section_key}:#{key} is not set in setup/config.yaml.  Please check before running again."
           abort()
        end
    end
end

# VM variables
box = "fisheyehq/mage2-ubuntu-16.04-php7.0"
name = config_file['vm']['name']
hostname = config_file['vm']['hostname']
cpus = config_file['vm']['cpus']
memory = config_file['vm']['memory']
ip_address = config_file['vm']['ip_address']
base_url = config_file['magento_setup']['base_url']
base_dir = "/var/www/" + base_url

# Composer auth variables
composer_auth_magentousername = config_file['composer_auth']['magentousername']
composer_auth_magentopassword = config_file['composer_auth']['magentopassword']
composer_auth_githuboauth = config_file['composer_auth']['githuboauth']

# Magento variables
mage_mode = config_file['magento_setup']['mode']
install_sample_data = config_file['magento_setup']['sample_data']
magento_install = config_file['magento_install']

Dir.mkdir("magento") unless File.exists?("magento")

Vagrant.configure(2) do |config|

  config.vm.box = box
  config.vm.hostname = hostname
  config.vm.box_version = ">= 0.0.2"

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.name = name
    vb.cpus = cpus
    vb.memory = memory
  end

  config.vm.network "private_network", ip: ip_address
  config.vm.synced_folder "./setup/", "/vagrant/setup/", type: config_file['vm']['sync_type']
  config.vm.synced_folder "./magento/", base_dir, type: config_file['vm']['sync_type']

  config.vm.provision :shell, :path => "setup/scripts/postfix-config.sh", :args => base_url

  config.vm.provision :shell, :path => "setup/scripts/composer-config.sh", :args => "#{composer_auth_magentousername} #{composer_auth_magentopassword} #{composer_auth_githuboauth}", :privileged => false

  config.vm.provision :shell, :path => "setup/scripts/nginx-config.sh", :args => "#{base_url} #{mage_mode}"

  if magento_install['install'] == 'y'

    config.vm.provision :shell, :path => "setup/scripts/magento-setup.sh", :args => "#{base_url} #{install_sample_data}", :privileged => false

    config.vm.provision :shell, :path => "setup/scripts/magento-install.sh", :args => "#{magento_install['admin_firstname']} #{magento_install['admin_lastname']} #{magento_install['admin_email']} #{magento_install['admin_user']} #{magento_install['admin_password']} #{base_url} #{magento_install['backend_frontname']} #{magento_install['language']} #{magento_install['currency']} #{magento_install['timezone']} #{magento_install['session_save']} #{magento_install['use_rewrites']} #{magento_install['default_country']} #{magento_install['admin_session_lifetime']} #{mage_mode}", :privileged => false

  end

  config.vm.provision :shell, :path => "setup/scripts/cron-config.sh", :args => base_dir

  config.vm.provision :shell, :path => "setup/scripts/final-config.sh", :args => "#{base_dir} #{ip_address} #{base_url}"

end
