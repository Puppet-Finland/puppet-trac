# This manifest is only used by Vagrant

$servermonitor = 'root@localhost'

include ::monit
include ::postgresql
include ::trac::config::git
include ::trac::config::inputfieldtrap
include ::trac::config::navadd
include ::trac::config::tocmacro
include ::webserver

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
}
