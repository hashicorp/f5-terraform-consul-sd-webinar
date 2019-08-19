output "F5_Elastic_Mgmt_IP" {
  value = "${aws_eip.mgmt_vip.public_ip}"
}

output "F5_Elastic_Virtual_Server_IP" {
  value = "${aws_eip.vs_vip.public_ip}"
}
