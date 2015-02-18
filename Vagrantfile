# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = 'jenkins.example.com'
  
  config.vm.network :forwarded_port, host: 8080, guest: 8080

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end

  config.vm.provision :shell, :path => "shell/librarian-puppet.sh"
  
  config.vm.provision 'puppet' do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file  = 'site.pp'
    puppet.module_path    = 'puppet/modules'
  end

  script = <<-SCRIPT
    ip=`facter ipaddress`
    echo Your Jenkins instance is ready.
    echo
    echo The interface can be reached at the following URI:
    echo  *  http://$ip:8080
  SCRIPT

  config.vm.provision 'shell',
    inline: script

end
