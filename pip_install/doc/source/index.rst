=============================
OpenStack-Ansible pip install
=============================

This role will install pip using the upstream pip installation script. Within
the installation of pip the role will create a .pip directory within the
deploying user's home folder and a blank selfcheck JSON file for pip to use to
keep track of versions.

It can also configure pip links that will restrict the package sources to
the OpenStack-Ansible repository.

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
