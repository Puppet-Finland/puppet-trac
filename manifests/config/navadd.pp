#
# == Class: trac::config::navadd
#
# Install TracNavadd plugin
#
class trac::config::navadd {

    include trac::params

    file { 'trac-navadd-directory':
        name => "/usr/local/lib/python${::trac::params::python_version}/dist-packages/navaddplugin",
        owner => root,
        group => root,
        source => 'puppet:///modules/trac/navaddplugin',
        recurse => true,
        require => Class['trac']
    }

    exec { 'trac-navadd-install':
        cwd => "/usr/local/lib/python${::trac::params::python_version}/dist-packages/navaddplugin/0.9",
        command => 'python setup.py install',
        onlyif => 'test ! -d /usr/local/lib/python*/dist-packages/NavAdd*',
        path => [ '/usr/local/bin', '/usr/bin' ],
        require => File['trac-navadd-directory'],
    }
}
