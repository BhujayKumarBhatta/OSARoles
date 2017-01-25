================================
Swift role for OpenStack-Ansible
================================

.. toctree::
   :maxdepth: 2

   configure-swift.rst

Default Variables
^^^^^^^^^^^^^^^^^

.. literalinclude:: ../../defaults/main.yml
   :language: yaml
   :start-after: under the License.

Example Playbook
^^^^^^^^^^^^^^^^

.. literalinclude:: ../../examples/playbook.yml
   :language: yaml

Tags
^^^^

This role supports two tags: ``swift-install`` and ``swift-config``

The ``swift-install`` tag can be used to install and upgrade.

The ``swift-config`` tag can be used to maintain configuration of the
service.
