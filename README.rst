================
elasticsearch-formula
================

A saltstack formula to manage elasticsearch 2.x and 5.x clusters on RHEL and Debian based systems.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``es-repo``
------------
Manage repo file on RHEL/CentOS and Debian systems.

``es-package``
------------
Install elasticsearch and additional prerequisite packages

``es-mount``
------------
Optionally configure non-statndard folders and mount additional devices if used
 
``es-config``
------------
Manage configuration file placement

``es-kernel``
------------
Apply kernal tweaks and system tuning options

``es-firewalld``
------------
Optionally setup firewalld rules for elasticsearch transport and disable iptables
Requires the firewall-formula or another method of managing the firewalld service

``es-iptables``
------------
Optionally setup iptables rules for elasticsearch transport and disable firewalld
Requires the firewall-formula or another method of managing the iptables service

``es-service``
------------
Sets up the elasticsearch service and makes sure it is running.
