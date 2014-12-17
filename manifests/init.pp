#
# == Class: trac
#
# Setup a Trac server that uses postgresql as the database backend and which is 
# hosted by Apache. LDAP authentication can be configured optionally.
#
# == Parameters
#
# [*branch*]
#   Name of the Trac branch to install. A list is available here:
# 
#   <http://svn.edgewall.org/repos/trac/branches>
#
# [*db_backend*]
#   Name of the database backend to use. Defaults to 'postgresql', which is also 
#   the only backend currently supported by this module.
# [*db_name*]
#   Name of the database used by Trac. Defaults to 'trac'.
# [*db_user_name*]
#   Database user for access the Trac database. Defaults to 'tracuser'.
# [*db_user_password*]
#   Password for the database user.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class trac
(
    $branch,
    $db_backend = 'postgresql',
    $db_name = 'trac',
    $db_user_name = 'tracuser',
    $db_user_password,
    $ldap_host = $::ldap_host,
    $ldap_port = $::ldap_port,
    $ldap_binddn = $::ldap_binddn,
    $ldap_bindpw = $::ldap_bindpw,
    $ldap_user_basedn = $::ldap_user_basedn
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_trac', 'true') != 'false' {

    class { 'trac::prequisites':
        db_backend => $db_backend,
    } 

    class { 'trac::install':
        branch => $branch,
    }

    include trac::config::common
    include trac::config::apache2

    # Database settings
    if $db_backend == 'postgresql' {
        class { 'trac::config::postgresql':
            db_name => "${db_name}",
            db_user_name => "${db_user_name}",
            db_user_password => "${db_user_password}"
        }
    }

    # LDAP settings
    class { 'trac::config::ldapauth':
        ldap_host => $ldap_host,
        ldap_port => $ldap_port,
        ldap_binddn => $ldap_binddn,
        ldap_bindpw => $ldap_bindpw,
        ldap_user_basedn => $ldap_user_basedn,
    }
}
}
