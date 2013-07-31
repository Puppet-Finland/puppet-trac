#
# == Class: trac::install
#
# Install Trac using easy_install. By default Trac will go to /usr/local.
#
class trac::install($branch)
{
    include python::setuptools

    exec { 'trac-easy_install':
        command => "easy_install http://svn.edgewall.org/repos/trac/branches/${branch}",

        # This file should always be present if Trac is installed 
        # using easy_install.
        creates => '/usr/local/bin/trac-admin',
        path => [ '/usr/local/bin', '/usr/bin' ],
        require => [ Class['trac::prequisites'], Class['python::setuptools'] ],
    }
}
