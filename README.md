# trac

A Puppet module for managing Trac

# Module usage

* [Class: trac](manifests/init.pp)
* [Define: trac::project](manifests/project.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Ubuntu 16.04

Ubuntu 14.04 may work, but it has not been tested with the latest version of 
this module.

It should work with minor modifications on any Debian/Ubuntu derivative. Adding 
support for other *NIX-like operating systems would be slightly more challenging 
due to the way how Apache2 is configured on Debian/Ubuntu.

For details see [params.pp](manifests/params.pp).

