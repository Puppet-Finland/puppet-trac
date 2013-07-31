#
# == Class: trac::config::tocmacro
#
# Install TocMacro plugin
#
class trac::config::tocmacro {
    exec { 'trac-easy_install-tocmacro':
        command => 'easy_install http://trac-hacks.org/svn/tocmacro/0.11',
        onlyif => 'test ! -d /usr/local/lib/python*/dist-packages/TracTocMacro*',
        path => [ '/usr/local/bin', '/usr/bin' ],
        require => Class['trac'],
    }
}
