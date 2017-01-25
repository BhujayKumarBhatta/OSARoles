Unbound Caching DNS Resolver Ansible Role
##################################

Ansible role to install and configure Unbound

.. image:: https://travis-ci.org/Logan2211/ansible-unbound.svg?branch=master
    :target: https://travis-ci.org/Logan2211/ansible-unbound

Default Variables
=================

.. literalinclude:: defaults/main.yml
   :language: yaml
   :start-after: under the License.

Required Variables
==================

None

Example Playbook
================

.. code-block:: yaml

    - name: Install unbound
      hosts: unbound
      user: root
      roles:
        - { role: "unbound" }
