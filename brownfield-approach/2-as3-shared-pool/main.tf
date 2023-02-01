# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = var.username
  password = var.password
}

# deploy shared webapp-pool using as3
resource "bigip_as3" "nginx" {
  as3_json    = file("nginx-pool.json")
}
