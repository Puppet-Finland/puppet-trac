#
# == Class: trac::params
#
# Defines some variables based on the operating system
#
class trac::params {

    # This module currently supports only Debian, so rougher $::osfamily checks 
    # are not necessary.

    case $::lsbdistcodename {
        /(xenial)/: {
            $python_version = '3.5'
        }
        /(trusty|wheezy)/: {
            $python_version = '2.7'
        }
        default: {
            fail("Unsupported OS: ${::lsbdistcodename}")
        }
    }
}
