#
# == Class: trac::config::postgresql
#
# Configure postgresql so that Trac can use it as a data store
#
class trac::config::postgresql
(
    $db_name,
    $db_user_name,
    $db_user_password,
    $auth_line
)
{

    # Create a database ('trac') an a user ('tracuser') for Trac
    postgresql::loadsql { 'trac-trac.sql':
        basename => 'trac',
    }

    Postgresql::Config::Auth::File <| title == 'default-pg_hba.conf' |> {
        postgresql_auth_lines +> "$auth_line",
    }


}
