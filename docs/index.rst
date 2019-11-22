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

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   aws-console
   terraform-1
   aws-marketplace          
   terraform-2
   aws-auto-scale
   clean-up
