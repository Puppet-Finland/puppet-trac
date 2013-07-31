#
# == Class: trac::prequisites
#
# Setup various Trac's prequisites. These would not be needed if we installed 
# Trac from operating system packages, which unfortunately tend to be obsolete.
#
class trac::prequisites
(
    $db_backend
)
{

    include apache2
    include apache2::config::python
    include python::subversion

    # Extra prequisites if we chose to use postgresql
    if $db_backend == 'postgresql' {
        include postgresql
        include python::psycopg2
    }
}
