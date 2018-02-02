#
# == Class: trac::absent
#
# Remove obsolete Trac configurations
#
class trac::absent {

    include ::apache2::params

    # See commit cf93da9828a3 for details
    file { "${::apache2::params::conf_d_dir}/trac-common":
        ensure => absent,
    }
}
