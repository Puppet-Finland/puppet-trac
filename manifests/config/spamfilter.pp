#
# == Class trac::config::xmlrpc
#
# Setup Trac (Bayesian) spam-filter
#
class trac::config::spamfilter
{
    include ::trac::params

    file { 'trac-spam-filter-directory':
        name    => "/usr/local/lib/python${::trac::params::python_version}/dist-packages/spam-filter",
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/trac/spam-filter',
        recurse => true,
        require => Class['::trac::install']
    }

    exec { 'trac-spam-filter-install':
        cwd     => "/usr/local/lib/python${::trac::params::python_version}/dist-packages/spam-filter",
        command => 'python setup.py install',
        onlyif  => 'test ! -d /usr/local/lib/python*/dist-packages/TracSpamFilter-*',
        path    => [ '/usr/local/bin', '/usr/bin' ],
        require => File['trac-spam-filter-directory'],
    }
}
