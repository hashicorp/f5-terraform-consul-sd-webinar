# Network Infrastructure Automation (NIA)

In this directory you will see a simple example of using NIA to "push" a configuration to the BIG-IP.

In the "as3" directory you saw an example of the BIG-IP "pulling" the configuration from Consul.  This requires that the BIG-IP is able to access the Consul service and it is responsible for updating the configuration.

In this directory we will use the utility `consul-terraform-sync` that will communicate with the Consul service.  When a change is detected it will push a configuration change to the BIG-IP.  

## Running this example

This assumes that you have already run the existing demonstration of running "terraform apply" in both the "terraform" and "as3" directories.

Start in the "as3" directory.  Run the command:

```
$ TF_VAR_declaration=event.json terraform apply
```

This will update the configuration of the BIG-IP to no longer communicate with Consul.  Instead it will expect that it will be receiving updates from `consul-terraform-sync`.

In the "nia" directory run 
```
consul-terraform-sync -config-file config.hcl 
```
You will see output that indicates that it has updated the BIG-IP configuration.  You can then modify the environment (stop the NGINX Docker container, add additional NGINX nodes) and see that updates will only occur when the environment is modified (vs. every 10 seconds in the previous example).

Example output
```
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Using previously-installed f5networks/bigip v1.5.0

Terraform has been successfully initialized!
Workspace "AS3" already exists
module.AS3.bigip_event_service_discovery.event_pools["nginx"]: Refreshing state... [id=~Consul_SD~Nginx~nginx_pool]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
module.AS3.bigip_event_service_discovery.event_pools["nginx"]: Refreshing state... [id=~Consul_SD~Nginx~nginx_pool]
module.AS3.bigip_event_service_discovery.event_pools["nginx"]: Modifying... [id=~Consul_SD~Nginx~nginx_pool]
module.AS3.bigip_event_service_discovery.event_pools["nginx"]: Modifications complete after 1s [id=~Consul_SD~Nginx~nginx_pool]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
module.AS3.bigip_event_service_discovery.event_pools["nginx"]: Refreshing state... [id=~Consul_SD~Nginx~nginx_pool]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

## More information

This example differs than the one that you will find on the Terraform registry.  Please see the following for another example: https://registry.terraform.io/modules/f5devcentral/app-consul-sync-nia/bigip/latest