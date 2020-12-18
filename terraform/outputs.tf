output "F5_IP" {
  value = module.bigip.0.mgmtPublicIP[0]
}

output "F5_Password" {
  value = module.bigip.0.bigip_password
}

output "F5_Username" {
  value = module.bigip.0.f5_username
}

output "F5_ssh" {
  value = "ssh -i ${aws_key_pair.demo.key_name}.pem admin@${module.bigip.0.mgmtPublicIP[0]}"
}

output "F5_UI" {
  value = "https://${module.bigip.0.mgmtPublicIP[0]}:8443"
}

output "Consul_UI" {
  value = "http://${aws_instance.consul.public_ip}:8500"
}
