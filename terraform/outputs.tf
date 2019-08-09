output "F5_Public_IP" {
value = "${aws_instance.F5.public_ip}"
}

output "F5_Virtual_Server_IP" {
  value = "${aws_eip.eip_vip.public_ip}"
}
