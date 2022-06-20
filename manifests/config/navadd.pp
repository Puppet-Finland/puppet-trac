#
# @summary
#   Install TracNavadd plugin
#
class trac::config::navadd {

    include ::trac::params

    file { 'trac-navadd-directory':
        name    => "/usr/local/lib/python${::trac::params::python_version}/dist-packages/navaddplugin",
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/trac/navaddplugin',
        recurse => true,
        require => Class['::trac::install'],
    }

    exec { 'trac-navadd-install':
        cwd     => "/usr/local/lib/python${::trac::params::python_version}/dist-packages/navaddplugin/trunk",
        command => 'python setup.py install',
        unless  => 'test -f /usr/local/lib/python2.7/dist-packages/NavAdd*',
        path    => [ '/usr/local/bin', '/usr/bin' ],
        require => File['trac-navadd-directory'],
    }
}
