#
# == Class: trac::config::postgresql
#
# Configure postgresql so that Trac can use it as a data store
#
class trac::config::postgresql
(
    $db_name,
    $db_user_name,
    $db_user_password
)
{

    include ::pf_postgresql::params

    # Create a database ('trac') an a user ('tracuser') for Trac
    pf_postgresql::loadsql { 'trac-trac.sql':
        basename   => 'trac',
        modulename => 'trac',
    }

    # Add an authentication line for Trac to postgresql pg_hba.conf. For details
    # look into pf_postgresql::config class.
    augeas { 'trac-pg_hba.conf':
        context => "/files${::pf_postgresql::params::pg_hba_conf}",
        changes => [
            'ins 0514 after 1',
            'set 0514/type local',
            "set 0514/database ${db_name}",
            "set 0514/user ${db_user_name}",
            'set 0514/method password'
        ],
        lens    => 'Pg_hba.lns',
        incl    => $::pf_postgresql::params::pg_hba_conf,
        onlyif  => "match *[user = \'${db_user_name}\'] size == 0",
        notify  => Class['pf_postgresql::service'],
    }
}
