provider "bigip" {
  address  = "${var.address}"
  username = "${var.username}"
  password = "${var.password}"
}

resource "bigip_as3" "nginx" {
  as3_json    = "${file("nginx.json")}"
  tenant_name = "consul_sd"
}
