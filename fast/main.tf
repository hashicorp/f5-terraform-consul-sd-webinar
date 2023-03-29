# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.11.1"
    }
  }
}
provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = var.username
  password = var.password
}

# generate zip file

data "archive_file" "template_zip" {
  type        = "zip"
  source_file = "ConsulWebinar.yaml"
  output_path = "ConsulWebinar.zip"
}

# deploy fast template

resource "bigip_fast_template" "consul-webinar" {
  name = "ConsulWebinar"
  source = "ConsulWebinar.zip"
  md5_hash = filemd5("ConsulWebinar.zip")
  depends_on = [data.archive_file.template_zip]
}

resource "bigip_fast_application" "nginx-webserver" {
  template        = "ConsulWebinar/ConsulWebinar"
  fast_json   = <<EOF
{
      "tenant": "Consul_SD",
      "app": "Nginx",
      "virtualAddress": "10.0.0.200",
      "virtualPort": 8080
}
EOF
  depends_on = [bigip_fast_template.consul-webinar]
}