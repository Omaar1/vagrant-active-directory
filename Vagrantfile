# -*- mode: ruby -*-
# vi: set ft=ruby :

vmname = "redinvoke-dc"
hostname = "redinvoke-dc"
domain_fqdn = "redinvoke.local"
domain_netbios = "RED"
domain_safemode_password = "P@ssw0rd"

Vagrant.configure("2") do |config|
  config.vm.define "dc" do |cfg|
    cfg.vm.box = "jborean93/WindowsServer2012R2"
    cfg.vm.hostname = hostname

    # use the plaintext WinRM transport and force it to use basic authentication.
    # NB this is needed because the default negotiate transport stops working
    #    after the domain controller is installed.
    #    see https://groups.google.com/forum/#!topic/vagrant-up/sZantuCM0q4
    cfg.winrm.transport = :plaintext
    cfg.winrm.basic_auth_only = true

    cfg.vm.communicator = "winrm"
    cfg.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    cfg.vm.network :private_network, ip: "192.168.56.5"

    cfg.vm.network :forwarded_port, guest: 389, host: 7389, id: "ldap", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 636, host: 7636, id: "ldaps", auto_correct: true

    cfg.vm.provision "shell", path: "scripts/remove_defender_core.ps1", privileged: false
    cfg.vm.provision "shell", path: "scripts/disable_wu.ps1", privileged: false
    cfg.vm.provision "shell", path: "scripts/disable_rdp_nla.ps1", privileged: false
    cfg.vm.provision "shell", path: "scripts/install_ad.ps1", privileged: false
    cfg.vm.provision "shell", reboot: true
    cfg.vm.provision "shell", path: "scripts/configure_ad.ps1", privileged: false, args: "'#{domain_fqdn}' '#{domain_netbios}' '#{domain_safemode_password}'"
    cfg.vm.provision "shell", path: "scripts/certificate.ps1", privileged: false, args: "'#{hostname}' '#{domain_fqdn}'"
    cfg.vm.provision "shell", reboot: true
    cfg.vm.provision "shell", path: "scripts/install_adexplorer.ps1", privileged: false
    cfg.vm.provision "shell", path: "scripts/password_policy.ps1", privileged: false, args: "'#{domain_fqdn}'"
    cfg.vm.provision "shell", path: "scripts/importusers.ps1", privileged: false, args: "'#{domain_fqdn}'"

    cfg.vm.provider "virtualbox" do |vb, override|
      vb.name = vmname
      vb.gui = false
      vb.customize ["modifyvm", :id, "--memory", 1024]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "16"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
      vb.customize ["modifyvm", :id, "--macaddress1", "auto"]
      vb.customize ["modifyvm", :id, "--macaddress2", "auto"]
    end
  end
end
