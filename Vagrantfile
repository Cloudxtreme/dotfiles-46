# -*- mode: ruby -*-
# vi: set ft=ruby :
# Inspired by: https://github.com/creack/dotfiles/blob/master/Vagrantfile

GIT_USERNAME = ENV['GIT_USERNAME']
GIT_EMAIL = ENV['GIT_EMAIL']


Vagrant::Config.run do |config|
  config.vm.define :junk do |junk_config|
    junk_config.vm.box = 'junk'
    junk_config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box'
  end

  config.vm.define :coreos do |coreos_config|
    coreos_config.vm.box = 'coreos'
    coreos_config.vm.box_url = 'http://storage.core-os.net/coreos/amd64-generic/dev-channel/coreos_production_vagrant.box'
  end

  config.vm.define :docker do |docker_config|
    docker_config.vm.box = 'docker'
    docker_config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box'

    ### Running first time
    pkg_cmd = "[ -f /usr/bin/git ] || ("

    # Install basic env, git/mercurial, docker dependencies, emacs, zsh, etc
    pkg_cmd << "apt-get update -qq; export DEBIAN_FRONTEND=noninteractive; apt-get install -q -y linux-image-extra-3.8.0-19-generic build-essential mercurial git lxc aufs-tools bsdtar htop most emacs24 zsh tmux ngrep tcpdump unzip ntp; "

    # Change default shell
    pkg_cmd << "chsh -s /bin/bash vagrant; "

    # Create docker group and add vagrant user to it
    pkg_cmd << "groupadd docker; "
    pkg_cmd << "usermod -a -G docker vagrant; "

    # Retrieve the dotfiles config
    pkg_cmd << "HOME=/home/vagrant make; "
    pkg_cmd << "[[ -n $GIT_USERNAME ]] && git config --global user.name $GIT_USERNAME; "
    pkg_cmd << "[[ -n $GIT_EMAIL ]] && git config --global user.email $GIT_EMAIL; "

    # Checkout golang source and install them
    pkg_cmd << "echo 'Cloning Go repository'; hg clone http://code.google.com/p/go /home/vagrant/goroot; "
    pkg_cmd << "cd /home/vagrant/goroot/src; ./all.bash; "

    # Make sure the GOPATH and GOROOT are correctly set
    pkg_cmd << "echo 'export GOPATH=~/go' >> /home/vagrant/.zshrc; export GOPATH=/home/vagrant/go; "
    pkg_cmd << "echo 'export GOROOT=~/goroot' >> /home/vagrant/.zshrc; export GOROOT=/home/vagrant/goroot; "
    pkg_cmd << "echo 'export GOBIN=$GOROOT/bin' >> /home/vagrant/.zshrc; export GOBIN=$GOROOT/bin; "
    pkg_cmd << "echo 'export PATH=$GOBIN:$PATH' >> /home/vagrant/.zshrc; export PATH=$GOBIN:$PATH; "

    # Install godef for symbol/tags lookup
    pkg_cmd << "go get code.google.com/p/rog-go/exp/cmd/godef; "
    # Install gocode completion
    pkg_cmd << "go get github.com/nsf/gocode; "
    # Install goflymake
    pkg_cmd << "go get github.com/dougm/goflymake; "
    # Install gocov
    pkg_cmd << "go get github.com/axw/gocov/gocov; "

    # Checkout docker sources
    pkg_cmd << "go get github.com/dotcloud/docker; ln -s /home/vagrant/go/src/github.com/dotcloud/docker /home/vagrant/docker; "
    pkg_cmd << "cd /home/vagrant/docker; git checkout master; "

    # Make sure we have the correct permissions
    pkg_cmd << "chown -R vagrant:vagrant /home/vagrant; "

    pkg_cmd << "); "

    docker_config.vm.provision :shell, :inline => pkg_cmd
  end
end