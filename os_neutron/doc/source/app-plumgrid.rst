============================================
Scenario - Using the PLUMgrid Neutron plugin
============================================

Installing source and host networking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Clone the PLUMgrid Ansible repository in the ``/opt/`` directory:

   .. code-block:: shell-session

       # git clone -b TAG \
       https://github.com/plumgrid/plumgrid-ansible.git \
       /opt/plumgrid-ansible

   Replace *``TAG``* with the current stable release tag.

#. PLUMgrid controls networking for the entire cluster. The bridges
   ``br-vxlan`` and ``br-vlan`` are present to prevent relevant
   containers from exiting with errors on infra hosts. They do not
   need to be attached to any host interface or a valid network.

#. PLUMgrid requires two networks: a `Management` and a `Fabric`
   network. The Management network is typically shared through the
   standard ``br-mgmt`` bridge and the Fabric network must be
   specified in the PLUMgrid configuration file as described below.
   The Fabric interface must be untagged and unbridged.

Neutron configuration
~~~~~~~~~~~~~~~~~~~~~

To set up the neutron configuration to install PLUMgrid as the core
neutron plugin, create a userspace variable file named
``/etc/openstack_deploy/user_pg_neutron.yml`` and insert the following
parameters:

#. Set the ``neutron_plugin_type`` parameter to ``plumgrid``:

   .. code-block:: yaml

      # Neutron Plugins
      neutron_plugin_type: plumgrid

#. In the same file, disable the installation of unnecessary
   ``neutron-agents`` in the ``neutron_services`` dictionary by
   setting their ``service_en`` parameters to ``False``:

   .. code-block:: yaml

      neutron_metering: False
      neutron_l3: False
      neutron_lbaas: False
      neutron_lbaasv2: False
      neutron_vpnaas: False


PLUMgrid configuration
~~~~~~~~~~~~~~~~~~~~~~

On the deployment host, create a PLUMgrid user variables file using
the sample in ``/opt/plumgrid-ansible/etc/user_pg_vars.yml.example``.
Copy that file to ``/etc/openstack_deploy/user_pg_vars.yml``. You must
configure the following parameters:

#. Replace ``PG_REPO_HOST`` with a valid repository URL hosting
   PLUMgrid packages:

   .. code-block:: yaml

      plumgrid_repo: PG_REPO_HOST

#. Replace ``INFRA_IPs`` with comma-separated Infrastructure Node IPs
   and ``PG_VIP`` with an unallocated IP on the management network.
   This IP is used to access the PLUMgrid UI:

   .. code-block:: yaml

      plumgrid_ip: INFRA_IPs
      pg_vip: PG_VIP

#. Replace ``FABRIC_IFC`` with the name of the interface to be used
   for PLUMgrid Fabric:

   .. note::

      PLUMgrid Fabric must be an untagged unbridged raw interface such
      as ``eth0``.

   .. code-block:: yaml

      fabric_interface: FABRIC_IFC

#. Fill in the ``fabric_ifc_override`` and ``mgmt_override`` dicts
   with node ``hostname: interface_name`` to override the default
   interface names.

#. Obtain a PLUMgrid License file, rename to ``pg_license`` and place
   it under ``/var/lib/plumgrid/pg_license`` on the deployment host.

Gateway hosts
~~~~~~~~~~~~~

PLUMgrid-enabled OpenStack clusters contain one or more gateway nodes
used for providing connectivity with external resources, such as
external networks, bare-metal servers, or network service appliances.
In addition to the `Management` and `Fabric` networks required by
PLUMgrid nodes, gateways require dedicated external interfaces
referred to as ``gateway_devs`` in the configuration files.

#. Add a ``gateway_hosts`` section to
   ``/etc/openstack_deploy/openstack_user_config.yml``:

   .. code-block:: yaml

      gateway_hosts:
        gateway1:
          ip: GW01_IP_ADDRESS
        gateway2:
          ip: GW02_IP_ADDRESS

   Replace ``*_IP_ADDRESS`` with the IP address of the ``br-mgmt``
   container management bridge on each Gateway host.

#. Add a ``gateway_hosts`` section to the end of the PLUMgrid
   ``user_pg_vars.yml`` file:

   .. note::

      This section must contain the hostnames and ``gateway_dev``
      names for each gateway in the cluster.

   .. code-block:: yaml

      gateway_hosts:
       - hostname: gateway1
         gateway_devs:
         - eth3
         - eth4

Installation
~~~~~~~~~~~~

#. Run the PLUMgrid playbooks before running the
   ``openstack-setup.yml`` playbook:

   .. code-block:: shell-session

      # cd /opt/plumgrid-ansible/plumgrid_playbooks
      # openstack-ansible plumgrid_all.yml

.. note::

   Contact PLUMgrid at info@plumgrid.com for an Installation Pack.
   This pack includes a full trial commercial license, packages,
   deployment documentation, and automation scripts for the entire
   work flow.
