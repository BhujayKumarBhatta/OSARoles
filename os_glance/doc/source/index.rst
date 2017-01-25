=============================
OpenStack-Ansible glance role
=============================

.. toctree::
   :maxdepth: 2

   configure-glance.rst

This role installs the following Upstart services:

    * glance-api
    * glance-registry

Default variables
~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../defaults/main.yml
   :language: yaml
   :start-after: under the License.

Required variables
~~~~~~~~~~~~~~~~~~

None

Example playbook
~~~~~~~~~~~~~~~~

.. literalinclude:: ../../examples/playbook.yml
   :language: yaml

Tags
~~~~

This role supports two tags: ``glance-install`` and ``glance-config``.
The ``glance-install`` tag can be used to install and upgrade. The
``glance-config`` tag can be used to manage configuration.

