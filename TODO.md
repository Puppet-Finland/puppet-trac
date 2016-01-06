# TODO

## Port to Apache 2.4

The fragments produced by this module seem to only work for Apache 2.2. The 
problem is that Access control and authorization has changed significantly in 
Apache 2.4:

* http://httpd.apache.org/docs/2.4/upgrading.html
* https://httpd.apache.org/docs/2.4/howto/auth.html
* https://httpd.apache.org/docs/2.4/howto/access.html
* https://httpd.apache.org/docs/2.4/mod/mod_authz_core.html

The old style conf.d/trac-myproject was setup like this:

    WSGIScriptAlias /myproject /var/lib/projects/myproject/wsgi/myproject.wsgi
    
    <Directory /var/lib/projects/myproject/wsgi>
        WSGIApplicationGroup %{GLOBAL}
        Order deny,allow
        Allow from all
    </Directory>

In Apache 2.4 this must be changed to

    WSGIScriptAlias /myproject /var/lib/projects/myproject/wsgi/myproject.wsgi
    
    <Directory /var/lib/projects/myproject/wsgi>
        WSGIApplicationGroup %{GLOBAL}
        Require all granted
    </Directory>

The DocumentRoot's authorization in the virtual host definition must be changed 
accordingly:

    <VirtualHost *:443>
        ServerAdmin admin@domain.com
        DocumentRoot /var/lib/projects/myproject/htdocs
        
        <Directory /var/lib/projects/myproject/htdocs>
            RedirectMatch ^/$ /myproject/login
            Require all granted
        </Directory>
        
        SSLEngine on
        SSLCertificateFile  /etc/ssl/certs/myproject.crt
        SSLCertificateKeyFile /etc/ssl/private/myproject.key
        
        BrowserMatch "MSIE [2-6]" \
        nokeepalive ssl-unclean-shutdown \
        downgrade-1.0 force-response-1.0
        BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
    </VirtualHost>

If old-style and new-style access control rules are mixed in Apache 2.4 one will 
probably stumble upon odd authorization errors:

* https://wiki.apache.org/httpd/ClientDeniedByServerConfiguration

Currently this Puppet module only produces Apache 2.2-compatible config files. 
In the near future the module will be modified to work with Apache 2.4. Support 
for Apache 2.2 will be dropped at that point.
