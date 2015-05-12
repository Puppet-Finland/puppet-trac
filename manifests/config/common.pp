#
# == Class: trac::config::common
#
# Setup the project area under which each individual project is placed
#
class trac::config::common {

    file { 'trac-projects':
        ensure => directory,
        name   => '/var/lib/projects',
        owner  => www-data,
        group  => root,
        mode   => '0755',
    }

    file { 'trac-egg-cache':
        ensure => directory,
        name   => '/var/lib/projects/egg-cache',
        owner  => www-data,
        group  => root,
        mode   => '0755',
    }
}
