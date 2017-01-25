OpenStack Ceilometer
####################

Ansible Role that installs and configures OpenStack Ceilometer.

This role will install the following:
    * ceilometer-api
    * ceilometer-agent-notification
    * ceilometer-collector
    * ceilometer-polling
    * ceilometer-registry

The role will configure Ceilometer to use MongoDB for data storage, but does
not install or configure MongoDB.

Default Variables
=================

.. literalinclude:: ../../defaults/main.yml
   :language: yaml
   :start-after: under the License.

Example Playbook
================

.. code-block:: yaml

    - name: Install ceilometer server
      hosts: ceilometer_all
      user: root
      roles:
        - { role: "os_ceilometer", tags: [ "os-ceilometer" ] }
      vars:
        external_lb_vip_address: 172.16.24.1
        internal_lb_vip_address: 192.168.0.1

Tags
====

This role supports two tags: ``ceilometer-install`` and ``ceilometer-config``.

The ``ceilometer-install`` tag can be used to install and upgrade.

The ``ceilometer-config`` tag can be used to maintain configuration of the service.
