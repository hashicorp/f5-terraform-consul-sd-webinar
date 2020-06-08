Terraform: Step #1
==================

Open up Putty on the Windows 2012 device and select the ubuntu host.

On the ubuntu host run the following command.

.. code-block:: shell
                 
  $ cd f5-terraform-consul-sd-webinar/terraform/
  $ terraform init
  $ terraform plan
  $ terraform apply              

.. warning:: If you see an error "OptInRequired" you will need to go to the
   next section to resolve this error.

The first step "init" is fetching providers or plug-ins that will be used to
connect to AWS.

"plan" will output actions that terraform will perform (dry-run).

"apply" will execute the actions.
