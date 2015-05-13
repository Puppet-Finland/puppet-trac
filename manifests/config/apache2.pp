#
# == Class: trac::config::apache2
#
# Basic configuration of Apache2 for hosting Trac. This does not include 
# per-project settings or optional LDAP settings.
#
class trac::config::apache2 {

    # We place this file into conf.d as we don't host multiple sites; 
    # all Apache2 configuration files are considered global.
    file { 'trac-trac-common':
        ensure  => present,
        name    => '/etc/apache2/conf.d/trac-common',
        content => template('trac/trac-common.erb'),
        owner   => root,
        group   => root,
        mode    => '0644',
        require => [ Class['apache2::install'], Class['trac::config::common'] ],
        notify  => Class['apache2::service'],
    }
}
