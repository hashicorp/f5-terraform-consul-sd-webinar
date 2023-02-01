# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Generate a tfvars file for AS3 installation
data "template_file" "tfvars" {
  template = file("../as3/terraform.tfvars.example")
  vars = {
    addr     = module.bigip.0.mgmtPublicIP[0]
    port     = "8443"
    username = "admin"
    pwd      = random_string.password.result
  }
}
data "template_file" "nia" {
  template = file("../nia/config.hcl.example")
  vars = {
    addr     = module.bigip.0.mgmtPublicIP[0]
    port     = "8443"
    username = "admin"
    pwd      = random_string.password.result
    consul   = aws_instance.consul.public_ip
  }
}
resource "local_file" "nia-config" {
  content  = data.template_file.nia.rendered
  filename = "../nia/config.hcl"
}

resource "local_file" "tfvars-as3" {
  content  = data.template_file.tfvars.rendered
  filename = "../as3/terraform.tfvars"
}

resource "local_file" "tfvars-fast" {
  content  = data.template_file.tfvars.rendered
  filename = "../fast/terraform.tfvars"
}

# Generate a tfvars file for "brownfield-approach" installation
resource "local_file" "tfvars-b1" {
  content  = data.template_file.tfvars.rendered
  filename = "../brownfield-approach/1-f5-brownfield-install-terraform/terraform.tfvars"
}

resource "local_file" "tfvars-b2" {
  content  = data.template_file.tfvars.rendered
  filename = "../brownfield-approach/2-as3-shared-pool/terraform.tfvars"
}
