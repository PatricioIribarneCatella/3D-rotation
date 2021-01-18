# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/bionic64'

  config.vm.network 'forwarded_port', guest: 4000, host: 4000
  config.vm.hostname = 'tp-rotation-3d'
  config.vm.provider 'virtualbox' do |vb|
    vb.memory = '2048'
    vb.name = config.vm.hostname
  end

  config.vm.provision 'shell', privileged: false, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y build-essential git make gnat zlib1g-dev
    sudo apt-get install -y python3-pip
    python3 -m pip install vsg
    git clone https://github.com/ghdl/ghdl
    cd ghdl
    ./configure --prefix=/usr/local
    make
    sudo make install
  SHELL
end
