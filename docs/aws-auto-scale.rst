AWS Auto Scale
==============

In the AWS Console find the "EC2" service.

In the left menu find "Auto Scaling Group"

.. image:: ./images/aws-auto-scaling-menu.png

Under the "Actions" menu select "Edit"

.. image:: ./images/aws-auto-scaling-edit.png

.. warning:: It may take a few minutes for the new instances to be created

On the BIG-IP you should see the new pool members get added.

.. image:: ./images/aws-auto-scaling-big-ip.png

On the NGINX page click on "Auto Refresh" you should see.

  .. image:: ./images/aws-auto-scaling-nginx-3.gif
