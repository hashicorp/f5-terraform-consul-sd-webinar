# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "address" {}
variable "port" {}
variable "username" {}
variable "password" {}
variable "as3_rpm" {
  default = "f5-appsvcs-3.17.1-1.noarch.rpm"
}
variable "as3_rpm_url" {
  default = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.17.1/f5-appsvcs-3.17.1-1.noarch.rpm"
}