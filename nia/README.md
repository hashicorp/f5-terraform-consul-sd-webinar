# Network Infrastructure Automation (NIA)

In this directory you will see an example of using [Network Infrastructure Automation (NIA)](https://www.consul.io/docs/nia) to "push" a configuration to the BIG-IP.

In the "as3" directory you saw an example of the BIG-IP "pulling" the configuration from Consul.  This requires that the BIG-IP is able to access the Consul service and it is responsible for updating the configuration.

In this directory we will use the utility `consul-terraform-sync` that will communicate with the Consul service.  When a change is detected it will push a configuration change to the BIG-IP.  

## Running this example

This assumes that you have already run the existing demonstration of running "terraform apply" in both the "terraform" directory.

Start in the "fast" directory.  Run the command:

```
$ terraform apply
```
The "fast" directory will upload a FAST template that will configure the BIG-IP to use Event-Driven Service Discovery.

This will update the configuration of the BIG-IP to no longer communicate with Consul.

Instead it will expect that it will be receiving updates from `consul-terraform-sync`.

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

## How this works

In the first step you are sending an AS3 declaration that specifies that [Event-Driven Service Discovery](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/declarations/discovery.html#event-driven-service-discovery) should be used.

```
...
        "nginx_pool": {
          "class": "Pool",
          "monitors": [
            "http"
          ],
          "members": [
            {
              "servicePort": 80,
              "addressDiscovery": "event"
            }
          ]
        }
...
```
When this is enabled, it creates a new API endpoint on the BIG-IP of `/mgmt/shared/service-discovery/task/~Consul_SD~Nginx~nginx_pool`

In the Terraform code that is used with NIA you will see that this endpoint is used to update the pool members based on the data that is stored in Consul.

```hcl
...
resource "bigip_event_service_discovery" "event_pools" {
  for_each = local.service_ids
  taskid = "~Consul_SD~Nginx~${each.key}_pool"
  dynamic "node" {
    for_each = local.grouped[each.key]
    content {
      id = node.value.node_address
      ip = node.value.node_address
      port = node.value.port
    }
  }
}
...
```
You could also create your own custom event driven endpoints without using AS3 by sending a POST request to `/mgmt/shared/service-discovery/task` with the following payload (assumes pool "test_pool" already exists).  Note that this will wipe out any existing pool members once you send an update.

This could be suitable in an environment where you want NIA to update an existing pool resource.
```
{
    "id": "test_pool",
    "schemaVersion": "1.0.0",
    "provider": "event",
    "resources": [
        {
            "type": "pool",
            "path": "/Common/test_pool",
            "options": {
                "servicePort": 8080
            }
        }
    ],
    "nodePrefix": "/Common/"
}
```
You would then be able to reference this with the taskid of `test_pool`.

To remove event-driven service discovery from `test_pool` you would then issue a `DELETE` to `/mgmt/shared/service-discovery/task/test_pool`.

## More information

This example differs than the one that you will find on the Terraform registry.  Please see the following for another example: https://registry.terraform.io/modules/f5devcentral/app-consul-sync-nia/bigip/latest