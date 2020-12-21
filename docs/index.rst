.. F5 BIG-IP Terraform & Consul Webinar - Zero Touch App Delivery with F5, Terraform & Consul documentation master file, created by
   sphinx-quickstart on Fri Nov 22 01:25:30 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Terraform and Consul
====================

During this lab you will make use of Terraform to deploy a BIG-IP, Consul
Server, and NGINX nodes.

Once these devices are deployed you will use Terraform to install AS3
onto the BIG-IP and deploy an AS3 declaration to use Consul for Service
Discovery to create a pool of the NGINX nodes.

You will then modify the Auto-Scale group of NGINX nodes to observe how
Consul get detect the new NGINX nodes and the BIG-IP will also be updated.

Steps You will Perform
======================

#. Connect to AWS Console
#. Use Terraform to deploy AWS infrastructure, Consul, NGINX, and BIG-IP instances
#. Use Terraform to install AS3 on BIG-IP and deploy AS3 configuration
#. Observe that AS3 is deployed and using Consul to detect location of NGINX instances
#. Use AWS autoscale to increase the number of NGINX instances and observe that Consul and BIG-IP detect the increase in NGINX instances automatically


Terms Used in this Lab
======================

About Terraform
~~~~~~~~~~~~~~~

Terraform is an automation tool from HashiCorp that can be used to automate and stardize infrastructure deployments.

About Consul
~~~~~~~~~~~~

Consul is software created by HashiCorp that provides service discovery of infrastructure.  Typically it makes use of a Consul agent that will register services with the Consul server.  This allows mutable infrastructure that can scale-out/in and always be identified at the correct location (IP address).

About BIG-IP
~~~~~~~~~~~~

F5 BIG-IP is a platform that can provide many high-availibility, security, and telemetry services in a reverse-proxy.

About AS3
~~~~~~~~~

Application Services Extension 3 (AS3) provides a declarative interface to the BIG-IP that enables ecosystem partners like HashiCorp to easily integrate with BIG-IP solutions.

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   aws-console
   terraform-1
   aws-marketplace          
   terraform-2
   aws-auto-scale
   nia
   clean-up
