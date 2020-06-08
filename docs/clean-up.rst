Clean-up!
---------

Using Terraform we can remove the resources that we created.

Under the AWS Console you should be able to see the instances that you created.

.. image:: ./images/clean-up-instances.png

On the Ubuntu host change into the following directory and run the command.

.. code-block:: shell
  
  $ cd ~/f5-terraform-consul-sd-webinar/terraform/
  $ terraform destroy

All done!
