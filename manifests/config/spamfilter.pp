#
# == Class trac::config::spamfilter
#
# Install TracSpamFilter
#
class trac::config::spamfilter {
    exec { 'trac-easy_install-spamfilter':
        command => 'easy_install TracSpamFilter',
        onlyif  => 'test ! -d /usr/local/lib/python*/dist-packages/TracSpamFilter*',
        path    => [ '/usr/local/bin', '/usr/bin' ],
        require => Class['trac'],
    }
}
