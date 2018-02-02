#!/bin/sh
#
# Prepare modulepath prior to running "puppet apply". First parameter
# should be the name of the module calling this script. This ensures that
# this script can be reused in other Puppet modules.

if [ "$1" = "" ]; then
    echo "ERROR: module name not given as first parameter!"
    exit 1
fi

THIS_MODULE=$1
CWD=`pwd`

# Install dependencies
apt-get update
apt-get -y install git
/opt/puppetlabs/puppet/bin/gem install librarian-puppet

# Prepare for librarian-puppet
cd /home/vagrant
mkdir -p modules
cp /vagrant/vagrant/Puppetfile .

# Run librarian-puppet
/opt/puppetlabs/puppet/bin/librarian-puppet install

# Copy over this in-development module to modules
# directory
mkdir -p "modules/${THIS_MODULE}"
cp -r /vagrant/* "modules/${THIS_MODULE}/"

cd $CWD
