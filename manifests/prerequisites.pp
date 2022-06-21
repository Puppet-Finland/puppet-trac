#
# @summary
#   Setup various Trac's prerequisites. These would not be needed if we installed
#   Trac from operating system packages, which unfortunately tend to be obsolete.
#
class trac::prerequisites
(
    $db_backend
)
{

    include ::apache2
    include ::apache2::config::wsgi

    # Extra prerequisites if we chose to use postgresql
    if $db_backend == 'postgresql' {
        include ::pf_postgresql
        include ::python::psycopg2
    }
}
