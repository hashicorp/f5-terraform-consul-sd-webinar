# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "app_url" {
  value = "http://${var.address}:8080"
}
