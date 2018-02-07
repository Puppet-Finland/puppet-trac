#
# == Define: trac::project
#
# Create a new Trac project.
#
# == Parameters
#
# [*manage_trac_ini*]
#   Manage (file permissions) of trac.ini. Valid values are true (default) and 
#   false. Set to false if some other module manages the file.
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
    Boolean            $manage_trac_ini = true,
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
    if $manage_trac_ini {
        file { 'trac-trac.ini':
            name    => "/var/lib/projects/${projectname}/conf/trac.ini",
            owner   => root,
            group   => root,
            mode    => '0644',
            require => Exec["trac-initenv-${projectname}"],
        }
    }

    file { 'trac-conf':
        name    => "/var/lib/projects/${projectname}/conf",
        owner   => root,
        group   => root,
        mode    => '0755',
        require => Exec["trac-initenv-${projectname}"],
    }

    file { 'trac-log':
        name    => "/var/lib/projects/${projectname}/log",
        owner   => www-data,
        group   => root,
        mode    => '0755',
        require => Exec["trac-initenv-${projectname}"],
    }

    file { 'trac-attachments':
        name    => "/var/lib/projects/${projectname}/attachments",
        owner   => www-data,
        group   => root,
        mode    => '0755',
        require => Exec["trac-initenv-${projectname}"],
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
