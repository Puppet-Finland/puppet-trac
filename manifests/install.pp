#
# @summary install Trac using easy_install.
#
class trac::install
(
  String $branch
)
{
  include python::setuptools

  exec { 'trac-easy_install':
    command => "easy_install https://svn.edgewall.org/repos/trac/branches/${branch}",

    # This file should always be present if Trac is installed 
    # using easy_install.
    creates => '/usr/local/bin/trac-admin',
    path    => ['/usr/local/bin', '/usr/bin'],
    require => [Class['trac::prerequisites'], Class['python::setuptools']],
  }
}
