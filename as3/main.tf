terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.8.0"
    }
  }
}
provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = var.username
  password = var.password
}
# pin to 1.1.2
#terraform {
#  required_providers {
#    bigip = "~> 1.1.2"
#  }
#}

# deploy application using as3
resource "bigip_as3" "nginx" {
  as3_json = file(var.declaration)
  #  tenant_name = "consul_sd"
  #  depends_on  = [null_resource.install_as3]
}
