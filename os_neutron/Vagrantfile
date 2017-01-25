# Runs various tests defined in the tox.ini
#
# To run everything but functional tests:
#   vagrant up --provision-with bootstrap
#
# To run docs, linters and functional:
#   vagrant up
#
# To run docs, linters and func_ovs tests:
#  TOX_ENV=func_ovs vagrant up
#
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
  # Run docs, linters, etc, but no functional tests
  config.vm.provision "bootstrap", type: "shell", inline: <<-SHELL
    sudo su -
    cd /vagrant
    apt-get update
    FUNCTIONAL_TEST=false ./run_tests.sh
  SHELL
  # Run functional tests
  config.vm.provision "func_test", type: "shell", inline: <<-SHELL
    sudo su -
    cd /vagrant
    tox -e #{ENV['TOX_ENV'] || "functional"}
  SHELL
end