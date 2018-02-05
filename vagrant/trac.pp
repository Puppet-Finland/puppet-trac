# This manifest is only used by Vagrant

$servermonitor = 'root@localhost'

include ::monit
include ::postgresql
include ::trac::config::git
include ::trac::config::inputfieldtrap
include ::trac::config::navadd
include ::trac::config::tocmacro
include ::trac::config::spamfilter
include ::webserver

# Fix error when attempting to load trac.sql to postgresql
# on this particular box:
#
# psql:/etc/postgresql/9.5/main/trac.sql:16: ERROR:  encoding "UTF8" does not 
# match locale "en_US"
#
class { 'locales':
    locales => ['en_US.UTF-8 UTF-8'],
}

class { '::trac':
    branch            => '1.2-stable',
    db_name           => 'trac',
    db_user_name      => 'tracuser',
    db_user_password  => 'tracpassword',
    use_ldap          => true,
    ldap_binddn       => 'cn=proxy,dc=example,dc=org',
    ldap_bindpw       => 'vagrant123',
    ldap_host         => 'ldap.example.org',
    ldap_port         => 389,
    ldap_user_basedn  => 'ou=People,dc=example,dc=org',
    ldap_dn_attribute => 'cn',
    require           => Class['::locales'],
}

trac::project { 'myproject':
    projectname => 'myproject',
}
