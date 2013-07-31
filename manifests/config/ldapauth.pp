#
# == Class: trac::config::ldapauth
#
# Configure LDAP authentication for Trac projects
#
class trac::config::ldapauth
(
    $ldap_host,
    $ldap_port,
    $ldap_binddn,
    $ldap_bindpw,
    $ldap_user_basedn
)
{

    include apache2::config::ldapauth

    # LDAP authentication settings for Apache2. We can use this array in all 
    # trac::project instances.
    $apache2_ldap_auth_lines = ["AuthBasicProvider ldap",
                                "AuthLDAPBindDN ${ldap_binddn}",
                                "AuthLDAPBindPassword ${ldap_bindpw}",
                                "AuthLDAPURL ldap://${ldap_host}:${ldap_port}/${ldap_user_basedn}?${ldap_dn_attribute}",
                                "AuthzLDAPAuthoritative on"]
}
