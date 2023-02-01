# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    bigip = {
      source = "f5networks/bigip"
    }
  }
  required_version = ">= 0.13"
}
