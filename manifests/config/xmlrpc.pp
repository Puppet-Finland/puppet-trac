#
# == Class trac::config::xmlrpc
#
# Setup Trac XML-RPC plugin and limit it's usage
#
class trac::config::xmlrpc
(
    $allow,
    $projectname
)
{
    include ::trac::params

    file { 'trac-xmlrpcplugin-directory':
        name    => "/usr/local/lib/python${::trac::params::python_version}/dist-packages/xmlrpcplugin",
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/trac/xmlrpcplugin',
        recurse => true,
        require => Class['trac']
    }

    exec { 'trac-xmlrpc-install':
        cwd     => "/usr/local/lib/python${::trac::params::python_version}/dist-packages/xmlrpcplugin/trunk",
        command => 'python setup.py install',
        onlyif  => 'test ! -d /usr/local/lib/python*/dist-packages/TracXMLRPC-*',
        path    => [ '/usr/local/bin', '/usr/bin' ],
        require => File['trac-xmlrpcplugin-directory'],
    }

    Apache2::Config::Locations <| title == 'default-locations' |> {
        location_lines +>
            [
            '# Trac XMLRPC plugin filters',
            "<LocationMatch ^/${projectname}/(rpc|jsonrpc|xmlrpc|login/rpc|login/jsonrpc|login/xmlrpc)$>",
            '   Order deny,allow',
            '   Deny from all',
            "   Allow from ${allow}",
            '</LocationMatch>',
            ]
    }
}
