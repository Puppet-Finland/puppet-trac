#
# @summary
#   Basic configuration of Apache2 for hosting Trac. This does not include 
#   per-project settings or optional LDAP settings.
#
class trac::config::apache2 {

    include ::apache2::params

    # We place this file into conf.d as we don't host multiple sites; 
    # all Apache2 configuration files are considered global.
    file { 'trac-trac-common.conf':
        ensure  => present,
        name    => "${::apache2::params::conf_d_dir}/trac-common.conf",
        content => template('trac/trac-common.conf.erb'),
        owner   => root,
        group   => root,
        mode    => '0644',
        require => [ Class['apache2::install'], Class['trac::config::common'] ],
        notify  => Class['apache2::service'],
    }
}
