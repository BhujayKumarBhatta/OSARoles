=====================================================
Scenario - Using the networking-calico Neutron plugin
=====================================================

Introduction
~~~~~~~~~~~~

This document describes the steps required to deploy Project Calico Neutron
networking with OpenStack-Ansible (OSA). These steps include:

- Configure OSA environment overrides.

- Configure OSA user variables.

- Execute the playbooks.

For additional configuration about Project Calico and its architecture, please
reference the `networking-calico`_ and `Project Calico`_ documentation.

.. _networking-calico: http://docs.openstack.org/developer/networking-calico/
.. _Project Calico: http://docs.projectcalico.org/en/latest/index.html

Prerequisites
~~~~~~~~~~~~~

#. The deployment environment has been configured according to OSA
   best-practices. This includes cloning OSA software and bootstrapping
   Ansible. See `OpenStack-Ansible Install Guide <index.html>`_
#. BGP peers configured to accept routing announcements from your hypervisors.
   By default, the hypervisor's default router is set as the BGP peer.

Configure OSA Environment for Project Calico
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Copy the etcd container definition to ``/etc/openstack_deploy/env.d/etcd.yml``
to enable the creation of the etcd cluster.

.. code-block:: yaml

  component_skel:
    etcd:
      belongs_to:
        - etcd_all
  container_skel:
    etcd_container:
      belongs_to:
        - infra_containers
        - shared-infra_containers
      contains:
        - etcd
      properties:
        service_name: etcd

Copy the neutron environment overrides to
``/etc/openstack_deploy/env.d/neutron.yml`` to disable the creation of the
neutron agents container, and implement the calico-dhcp-agent hosts group
containing all compute hosts.

.. code-block:: yaml

  component_skel:
    neutron_calico_dhcp_agent:
      belongs_to:
      - neutron_all

  container_skel:
    neutron_agents_container:
      contains: {}
    neutron_calico_dhcp_agent_container:
      belongs_to:
        - compute_containers
      contains:
        - neutron_calico_dhcp_agent
      properties:
        is_metal: true
        service_name: neutron

Configure networking-calico Neutron Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set the following in ``/etc/openstack_deploy/user_variables.yml``.

.. code-block:: yaml

  neutron_plugin_type: ml2.calico
  nova_network_type: calico

Installation
~~~~~~~~~~~~

After multi-node OpenStack cluster is configured as detailed above; start
the OpenStack deployment as listed in the OpenStack-Ansible Install guide by
running all playbooks in sequence on the deployment host
