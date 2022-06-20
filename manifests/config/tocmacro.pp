#
# @summary
#   Install TocMacro plugin
#
class trac::config::tocmacro {
    exec { 'trac-easy_install-tocmacro':
        command => 'easy_install https://trac-hacks.org/svn/tocmacro/0.11',
        onlyif  => 'test ! -f /usr/local/lib/python*/dist-packages/TracTocMacro*',
        path    => [ '/usr/local/bin', '/usr/bin' ],
        require => [ Class['::trac::install'], Class['python::setuptools'] ],
    }
}
