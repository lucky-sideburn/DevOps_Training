ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'


Vagrant.configure("2") do |config|


  # Use CentOS 7
  config.vm.box = "centos/7"
  config.ssh.forward_agent=true
  config.ssh.insert_key = false




  # Setup 1 cpus and 1024 MB of memory for each instance
  #Sepcifing SPECS
  config.vm.provider :libvirt do |v|
        v.memory = 1024
        v.cpus = 1
  end

  # Run the provision install scripts
  config.vm.provision "shell", path: "script1.sh"


  config.vm.define "master" do |master|
    
   # Master 0 is 192.168.50.4
     #master.vm.box = "centos/7"
     master.vm.hostname = "master-node"
     master.vm.network "private_network", ip: "192.168.121.10"
     master.vm.synced_folder "./master_files", "/vagrant"
     #master.vm.hostname="masterCentOs"
  end

 end  
