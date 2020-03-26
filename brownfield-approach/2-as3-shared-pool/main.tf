provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = "${var.username}"
  password = "${var.password}"
}

# download rpm
resource "null_resource" "download_as3" {
  provisioner "local-exec" {
    command = "wget ${var.as3_rpm_url}"
  }
}

# install rpm to BIG-IP
resource "null_resource" "install_as3" {
  provisioner "local-exec" {
    command = "./install_as3.sh ${var.address}:${var.port} admin:${var.password} ${var.as3_rpm}"
  }
  depends_on = [null_resource.download_as3]
}

# deploy shared webapp-pool using as3
resource "bigip_as3" "nginx" {
  as3_json    = "${file("nginx-pool.json")}"
  config_name = "consul"
  depends_on  = [null_resource.install_as3]
}