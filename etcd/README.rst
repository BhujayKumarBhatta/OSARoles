etcd Ansible Role
##################################

Ansible role to install and configure etcd clusters and proxies

.. image:: https://travis-ci.org/Logan2211/ansible-etcd.svg?branch=master
    :target: https://travis-ci.org/Logan2211/ansible-etcd

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

    - name: Install etcd
      hosts: etcd
      user: root
      roles:
        - { role: "etcd" }
