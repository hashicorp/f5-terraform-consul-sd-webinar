terraform {
  required_providers {
    bigip = {
      source  = "f5networks/bigip"
      version = "~> 1.8.0"
    }
  }
}
locals {

  # Create a map of service names to instance IDs
  service_ids = transpose({
    for id, s in var.services : id => [s.name]
  })

  # Group service instances by name
  grouped = { for name, ids in local.service_ids :
    name => [
      for id in ids : var.services[id]
    ]
  }

}
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
