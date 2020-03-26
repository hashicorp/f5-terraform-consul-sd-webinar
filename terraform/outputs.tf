output "F5_IP" {
  value = "${aws_eip.f5.public_ip}"
}

output "F5_Password" {
  value = "${random_string.password.result}"
}

output "F5_Username" {
  value = "admin"
}

output "F5_UI" {
  value = "https://${aws_eip.f5.public_ip}:8443"
}

output "Consul_UI" {
  value = "http://${aws_instance.consul.public_ip}:8500"
}
