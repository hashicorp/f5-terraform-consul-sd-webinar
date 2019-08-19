resource "tls_private_key" "demo" {
  algorithm = "RSA"
}

resource "aws_key_pair" "demo" {
  public_key = "${tls_private_key.demo.public_key_openssh}"
}

resource "null_resource" "key" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.demo.private_key_pem}\" > key.pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 key.pem"
  }
}
