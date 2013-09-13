#
# == Define: trac::project
#
# Create a new Trac project.
#
define trac::project
(
    $projectname,
    $db_backend = 'postgresql'
)
{

    # Fetch LDAP authentication settings from generic Trac configuration
    $apache2_auth_lines = $::trac::config::ldapauth::apache2_ldap_auth_lines

    # Apache2 authentication settings (among other things) are in this file
    file { "trac-${projectname}":
        name => "/etc/apache2/conf.d/trac-${projectname}",
        content => template('trac/trac-project.erb'),
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => [ Class['apache2::install'], Class['trac::config::common'] ],
        notify => Class['apache2::service'],
    }

    # We only manage permissions of the following files and directories
    file { 'trac-trac.ini':
        name => "/var/lib/projects/${projectname}/conf/trac.ini",
        owner => root,
        group => root,
        mode => 644,
    }

    file { 'trac-log':
        name => "/var/lib/projects/${projectname}/log",
        owner => www-data,
        group => root,
        mode => 755,
    }

    file { 'trac-attachments':
        name => "/var/lib/projects/${projectname}/attachments",
        owner => www-data,
        group => root,
        mode => 755,
    }

    # If we add database backends we need to modify this
    if $db_backend == 'postgresql' {
        exec { "trac-initenv-${projectname}":
            command => "trac-admin /var/lib/projects/${projectname} initenv ${projectname} postgres://${db_user_name}:${db_user_password}@/${db_name}",
            creates => "/var/lib/projects/${projectname}",
            path => [ '/usr/local/bin', '/usr/bin' ],
            require => Class['trac::config::postgresql'],
        }
    }
}
