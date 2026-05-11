# Copyright IBM Corp. 2019, 2026
# SPDX-License-Identifier: MPL-2.0

output "app_url" {
  value = "http://${var.address}:8080"
}