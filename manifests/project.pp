#
# == Define: trac::project
#
# Create a new Trac project.
#
# == Parameters
#
# [*projectname*]
#   The name of the project. This needs to be string. Defaults to resource 
#   $title.
# [*use_ldap*]
#   Whether this Trac instance authenticates from LDAP. Valid values are true 
#   and false. Defaults to the value of $::trac::use_ldap. Note that if this is 
#   set to true, $::trac::use_ldap also needs be true, or LDAP settings will be 
#   missing.
# [*db_backend*]
#   The database backend to use. Defaults to 'postgresql', which is currently 
#   the only supported option.
#
define trac::project
(
    String             $projectname = $title,
    Optional[Boolean]  $use_ldap = undef,
    Enum['postgresql'] $db_backend = 'postgresql'
)
{
    include ::apache2::params

    $configure_apache2_ldap_auth = $use_ldap ? {
        undef   => $::trac::use_ldap,
        default => $use_ldap,
    }

    if $configure_apache2_ldap_auth {
        # Fetch LDAP authentication settings from generic Trac configuration
        $apache2_auth_lines = $::trac::config::ldapauth::apache2_ldap_auth_lines

        # Remove obsolete config file (see commit cf93da9828a3)
        file { "${::apache2::params::conf_d_dir}/trac-${projectname}":
            ensure => absent,
        }

        # Apache2 authentication settings (among other things) are in this file
        file { "trac-${projectname}.conf":
            ensure  => present,
            name    => "${::apache2::params::conf_d_dir}/trac-${projectname}.conf",
            content => template('trac/trac-project.conf.erb'),
            owner   => root,
            group   => root,
            mode    => '0644',
            require => [ Class['apache2::install'], Class['trac::config::common'] ],
            notify  => Class['apache2::service'],
        }
    }

    # We only manage permissions of the following files and directories
    file { 'trac-trac.ini':
        name  => "/var/lib/projects/${projectname}/conf/trac.ini",
        owner => root,
        group => root,
        mode  => '0644',
    }

    file { 'trac-conf':
        name  => "/var/lib/projects/${projectname}/conf",
        owner => root,
        group => root,
        mode  => '0755',
    }

    file { 'trac-log':
        name  => "/var/lib/projects/${projectname}/log",
        owner => www-data,
        group => root,
        mode  => '0755',
    }

    file { 'trac-attachments':
        name  => "/var/lib/projects/${projectname}/attachments",
        owner => www-data,
        group => root,
        mode  => '0755',
    }

    file { "trac-${projectname}-wsgi":
        ensure  => directory,
        name    => "/var/lib/projects/${projectname}/wsgi",
        owner   => root,
        group   => root,
        mode    => '0755',
        require => Exec["trac-initenv-${projectname}"],
    }

    file { "trac-${projectname}.wsgi":
        ensure  => present,
        name    => "/var/lib/projects/${projectname}/wsgi/${projectname}.wsgi",
        content => template('trac/project.wsgi.erb'),
        owner   => root,
        group   => root,
        mode    => '0644',
        require => File["trac-${projectname}-wsgi"],
    }

    # If we add database backends we need to modify this
    if $db_backend == 'postgresql' {
        exec { "trac-initenv-${projectname}":
            command => "trac-admin /var/lib/projects/${projectname} initenv ${projectname} postgres://${::trac::config::postgresql::db_user_name}:${::trac::config::postgresql::db_user_password}@/${::trac::config::postgresql::db_name}",
            creates => "/var/lib/projects/${projectname}",
            path    => [ '/usr/local/bin', '/usr/bin' ],
            require => Class['trac::config::postgresql'],
        }
    }
}
