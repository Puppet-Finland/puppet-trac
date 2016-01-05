#
# == Class: trac::params
#
# Defines some variables based on the operating system
#
class trac::params {

    # This module currently supports only Debian, so rougher $::osfamily checks 
    # are not necessary.

    case $::lsbdistcodename {
        'trusty': {
            $python_version = '2.7'
        }
        'wheezy': {
            $python_version = '2.7'
        }
        'squeeze': {
            $python_version = '2.6'
        }
        default: {
            fail("Unsupported OS: ${::lsbdistcodename}")
        }
    }
}
