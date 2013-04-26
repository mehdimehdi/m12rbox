Vagrant::Config.run do |config|

  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.host_name = "m12rbox"
  config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file = "m12rbox.pp"
  end
  
end
