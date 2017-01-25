==================================
Gnocchi role for OpenStack-Ansible
==================================

This Ansible role installs and configures OpenStack gnocchi.

The gnocchi API is served using Apache mod_wsgi by default.

This role supports configuration of file, swift and ceph storage backends. By
default, the file backend is used.

This role also ships with an Ansible library, `gnocchi` that the role uses to
manage archive policies and archive policy rules. By default, three policies
are configured: low, medium, and high. A single archive policy rule is
configured setting the `low` policy as the default for all metrics.

Default variables
~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../defaults/main.yml
   :language: yaml
   :start-after: under the License.

Example playbook
~~~~~~~~~~~~~~~~

.. literalinclude:: ../../examples/playbook.yml
   :language: yaml

Tags
~~~~

This role supports two tags: ``gnocchi-install`` and
``gnocchi-config``. The ``gnocchi-install`` tag can be used to install
and upgrade. The ``gnocchi-config`` tag can be used to maintain the
configuration of the service.
