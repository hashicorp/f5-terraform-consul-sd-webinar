provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = "${var.username}"
  password = "${var.password}"
}

# deploy application using as3
resource "bigip_as3" "nginx" {
  as3_json    = "${file("nginx.json")}"
  tenant_name = "consul_sd"
#  depends_on  = [null_resource.install_as3]
}
