# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
current_dir = File.dirname(File.expand_path(__FILE__))
yaml_file = YAML.load_file("#{current_dir}/config.yaml")
vagrant_config = yaml_file['vagrant_config']

Vagrant.configure(2) do |config|

  config.vm.box = vagrant_config['vm']['box']
  config.vm.hostname = vagrant_config['vm']['hostname']

  config.vm.provider "virtualbox" do |vb|
    vb.name = vagrant_config['vm']['name']
    vb.memory = vagrant_config['vm']['memory']
    vb.cpus = vagrant_config['vm']['cpus']
  end

  config.vm.provider "parallels" do |prl, override|
    prl.name = vagrant_config['vm']['name']
    prl.memory = vagrant_config['vm']['memory']
    prl.cpus = vagrant_config['vm']['cpus']
    override.vm.box = vagrant_config['vm']['parallels-box']
  end
  
  config.vm.network "private_network", ip: vagrant_config['network']['ip_address']
  config.vm.synced_folder vagrant_config['network']['sync_dir'], "/var/www/" + vagrant_config['vm']['hostname'], type: vagrant_config['network']['sync_type']
  config.vm.synced_folder ".", "/vagrant", type: vagrant_config['network']['sync_type']
  
  config.vm.provision :shell, :path => "bootstrap.sh"

end