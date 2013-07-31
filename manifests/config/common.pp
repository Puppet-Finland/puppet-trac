#
# == Class: trac::config::common
#
# Setup the project area under which each individual project is placed
#
class trac::config::common {

    file { 'trac-projects':
        name => '/var/lib/projects',
        ensure => directory,
        owner => www-data,
        group => root,
        mode => 755,
    }
}
