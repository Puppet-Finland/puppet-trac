#
# == Class: trac::config::git
#
# Install TracGit plugin
#
class trac::config::git {
    exec { 'trac-easy_install-git':
        command => 'easy_install http://github.com/hvr/trac-git-plugin/tarball/master',
        onlyif => 'test ! -d /usr/local/lib/python*/dist-packages/TracGit*',
        path => [ '/usr/local/bin', '/usr/bin' ],
        require => Class['trac'],
    }
}
