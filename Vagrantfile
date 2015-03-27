nodes = [
    {:hostname => 'orientdb-node0', :ip => '192.168.0.100', :box => 'ubuntu/trusty64', :ram => 1024}
]
  
Vagrant.configure(2) do |config|
  
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.hostname = node[:hostname]
      node_config.vm.network :private_network, ip: node[:ip]
      node_config.vm.network "forwarded_port", guest: 2480, host: 2480
      node_config.vm.network "forwarded_port", guest: 2424, host: 2424
      
      memory = node[:ram] ? node[:ram] : 512;
      
      node_config.vm.provider "virtualbox" do |v|
        v.name = node[:hostname]
        v.gui = false
        v.cpus = 2
        v.memory = memory
        v.customize ["modifyvm", :id, "--cpuexecutioncap", "25"]
      end
    end
  end
  
  config.vm.provision "shell", path: "install.sh", privileged: false
  
end