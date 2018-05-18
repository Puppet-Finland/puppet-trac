# trac

A Puppet module for managing Trac instances that may authenticate from LDAP.

# Module usage

Setup Trac instance with LDAP authentication and a project which uses a customized trac.ini:

    class { '::trac':
      manage            => true,
      branch            => '1.2-stable',
      db_name           => 'trac',
      db_user_name      => 'tracuser',
      db_user_password  => 'secret',
      use_ldap          => true,
      ldap_binddn       => 'cn=proxy,dc=example,dc=org',
      ldap_bindpw       => 'secret',
      ldap_host         => 'ldap.example.org',
      ldap_port         => 389,
      ldap_user_basedn  => 'ou=People,dc=example,dc=org',
      ldap_dn_attribute => 'cn',
    }
    
    trac::project { 'openvpn':
      projectname     => 'myproject',
      manage_trac_ini => false,
    }

For further details see [init.pp](manifests/init.pp) and [project.pp](manifests/project.pp).

This module can be easily tested with Vagrant, see [Vagrantfile](Vagrantfile).


