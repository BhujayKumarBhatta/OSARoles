==================================================
Configure keystone as a federated Service Provider
==================================================

In OpenStack-Ansible, keystone is set up to use Apache with ``mod_wsgi``.
The additional configuration of keystone as a federation service provider
adds Apache ``mod_shib`` and configures it to respond to specific locations
requests from a client.

.. note::

   There are alternative methods of implementing
   federation, but at this time only SAML2-based federation using
   the Shibboleth SP is instrumented in Openstack-Ansible.

When requests are sent to those locations, Apache hands off the
request to the ``shibd`` service.

.. note::

   Handing off happens only with requests pertaining to authentication.

Handle the ``shibd`` service configuration through
the following files in ``/etc/shibboleth/`` in the keystone
containers:

* ``sp-cert.pem``, ``sp-key.pem``: The ``os-keystone-install.yml`` playbook
   uses these files generated on the first keystone container to replicate
   them to the other keystone containers. The SP and the IdP use these files
   as signing credentials in communications.
* ``shibboleth2.xml``: The ``os-keystone-install.yml`` playbook writes the
  file's contents, basing on the structure of the configuration
  of the ``keystone_sp`` attribute in the
  ``/etc/openstack_deploy/user_variables.yml`` file. It contains
  the list of trusted IdP's, the entityID by which the SP is known,
  and other facilitating configurations.
* ``attribute-map.xml``: The ``os-keystone-install.yml`` playbook writes
  the file's contents, basing on the structure of the configuration
  of the ``keystone_sp`` attribute in the
  ``/etc/openstack_deploy/user_variables.yml`` file. It contains
  the default attribute mappings that work for any basic
  Shibboleth-type IDP setup, but also contains any additional
  attribute mappings set out in the structure of the ``keystone_sp``
  attribute.
* ``shibd.logger``: This file is left alone by OpenStack-Ansible. It is useful
  when troubleshooting issues with federated authentication, or
  when discovering what attributes published by an IdP
  are not currently being understood by your SP's attribute map.
  To enable debug logging, change ``log4j.rootCategory=INFO`` to
  ``log4j.rootCategory=DEBUG`` at the top of the file. The
  log file is output to ``/var/log/shibboleth/shibd.log``.

Configure keystone-to-keystone (k2k)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following settings must be set to configure a service provider (SP):

#. ``keystone_public_endpoint`` is automatically set by default
   to the public endpoint's URI. This performs redirections and
   ensures token references refer to the public endpoint.

#. ``horizon_keystone_endpoint`` is automatically set by default
   to the public v3 API endpoint URL for keystone. Web-based single
   sign-on for horizon requires the use of the keystone v3 API.
   The value for this must use the same DNS name or IP address
   registered in the SSL certificate used for the endpoint.

#. It is a requirement to have a HTTPS public endpoint for the
   keystone endpoint if the IdP is ADFS.
   Keystone or an SSL offloading load balancer provides the endpoint.

#. Set ``keystone_service_publicuri_proto`` to https.
   This ensures keystone publishes https in its references
   and ensures that Shibboleth is configured to know that it
   expects SSL URL's in the assertions (otherwise it will invalidate
   the assertions).

#. ADFS requires that a trusted SP have a trusted certificate that
   is not self-signed.

#. Ensure the endpoint URI and the certificate match when using SSL for the
   keystone endpoint. For example, if the certificate does not have
   the IP address of the endpoint, then the endpoint must be published with
   the appropriate name registered on the certificate. When
   using a DNS name for the keystone endpoint, both
   ``keystone_public_endpoint`` and ``horizon_keystone_endpoint`` must
   be set to use the DNS name.

#. ``horizon_endpoint_type`` must be set to ``publicURL`` to ensure that
   horizon uses the public endpoint for all its references and
   queries.

#. ``keystone_sp`` is a dictionary attribute which contains various
   settings that describe both the SP and the IDP's it trusts. For example:

   .. code-block:: yaml

      keystone_sp:
        cert_duration_years: 5
        trusted_dashboard_list:
          - "https://{{ external_lb_vip_address }}/auth/websso/"
        trusted_idp_list:
          - name: 'testshib-idp'
            entity_ids:
              - 'https://idp.testshib.org/idp/shibboleth'
            metadata_uri: 'http://www.testshib.org/metadata/testshib-providers.xml'
            metadata_file: 'metadata-testshib-idp.xml'
            metadata_reload: 1800
            federated_identities:
              - domain: Default
                project: fedproject
                group: fedgroup
                role: _member_
            protocols:
              - name: saml2
                mapping:
                  name: testshib-idp-mapping
                  rules:
                    - remote:
                        - type: eppn
                      local:
                        - group:
                            name: fedgroup
                            domain:
                              name: Default
                        - user:
                            name: '{0}'

#. ``cert_duration_years`` designates the valid duration for the SP's
   signing certificate (for example, ``/etc/shibboleth/sp-key.pem``).

#. ``trusted_dashboard_list`` designates the list of trusted URLs that
   keystone accepts redirects for Web Single-Sign. This
   list contains all URLs that horizon is presented on,
   suffixed by ``/auth/websso/``. This is the path for horizon's WebSSO
   component.

#. ``trusted_idp_list`` is a dictionary attribute containing the list
   of settings which pertain to each trusted IdP for the SP.

#. ``trusted_idp_list.name`` is IDP's name. Configure this in
    in keystone and list in horizon's login selection.

#. ``entity_ids`` is a list of reference entity IDs. This specify's the
    redirection of the login request to the SP when authenticating to
    IdP.

#. ``metadata_uri`` is the location of the IdP's metadata. This provides
   the SP with the signing key and all the IdP's supported endpoints.

#. ``metadata_file`` is the file name of the local cached version of
   the metadata which will be stored in ``/var/cache/shibboleth/``.

#. ``metadata_reload`` is the number of seconds between metadata
   refresh polls.

#. ``federated_identities`` is a mapping list of domain, project, group, and
   users. See
   `Configure Identity Service (keystone) mappings`_
   for more information.

#. ``protocols`` is a list of protocols supported for the IdP and the set
   of mappings and attributes for each protocol. This only supports protocols
   with the name ``saml2``.

#. ``mapping`` is the local to remote mapping configuration for federated
   users. See `Configure Identity Service (keystone) mappings`_
   for more information.

.. _Configure Identity Service (keystone) mappings: configure-federation-mapping.html
