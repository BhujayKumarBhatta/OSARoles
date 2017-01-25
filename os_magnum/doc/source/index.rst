========================
OpenStack-Ansible Magnum
========================

Ansible role that installs and configures OpenStack Magnum. Magnum is
installed behind the Apache webserver listening on port 9511 by default.


Default variables
~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../defaults/main.yml
   :language: yaml
   :start-after: under the License.

Required variables
~~~~~~~~~~~~~~~~~~

This list is not exhaustive. See role internals for further details.

.. code-block:: yaml

    # Magnum TCP listening port
    magnum_service_port: 9511

    # Magnum service protocol http or https
    magnum_service_proto: http

    # Magnum Galera address of internal load balancer
    magnum_galera_address: "{{ internal_lb_vip_address }}"

    # Magnum Galera database name
    magnum_galera_database_name: magnum_service

    # Magnum Galera username
    magnum_galera_user: magnum

    # Magnum rabbit userid
    magnum_rabbitmq_userid: magnum

    # Magnum rabbit vhost
    magnum_rabbitmq_vhost: /magnum

Example playbook
~~~~~~~~~~~~~~~~

.. literalinclude:: ../../examples/playbook.yml
   :language: yaml

Tags
~~~~

This role supports two tags: ``magnum-install`` and ``magnum-config``.
The ``magnum-install`` tag can be used to install and upgrade. The
``magnum-config`` tag can be used to maintain configuration of the
service.
