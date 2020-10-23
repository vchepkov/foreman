# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vagrant.plugins = "vagrant-hosts"

  config.vm.provider :virtualbox do |vb|
    vb.auto_nat_dns_proxy = false
    vb.default_nic_type = "virtio"
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
  end

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/7"
  config.vm.hostname = "foreman.localdomain"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 443, host: 8443

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.50.20"

  config.vm.provision :hosts do |h|
    h.add_localhost_hostnames = false
    h.add_host '192.168.50.20', ['foreman.localdomain', 'foreman']
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    vb.name   = "foreman"
    vb.memory = "8192"
    vb.cpus   = "2"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    yum -y install https://yum.theforeman.org/releases/2.1/el7/x86_64/foreman-release.rpm
    yum -y install https://fedorapeople.org/groups/katello/releases/yum/3.16/katello/el7/x86_64/katello-repos-latest.rpm
    yum -y install https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
    yum -y install epel-release centos-release-scl-rh
    yum -y update
    yum -y install katello
  SHELL
end
