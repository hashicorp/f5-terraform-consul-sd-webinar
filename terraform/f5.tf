resource "random_string" "password" {
  length  = 10
  special = false
}

resource "aws_instance" "f5" {

  # F5 BIGIP-15.0.1.1-0.0.3 PAYG-Good 25Mbps-191118135436 for AWS region eu-central-1
  # ami = "ami-0f175be61eaf4f898"
  
  # F5 BIGIP-15.0.1.1-0.0.3 PAYG-Good 25Mbps-191118135436 for AWS region us-east-1
  ami = "ami-00eeec1a00568822c"

  instance_type               = "m5.xlarge"
  private_ip                  = "10.0.0.200"
  associate_public_ip_address = true
  subnet_id                   = "${module.vpc.public_subnets[0]}"
  vpc_security_group_ids      = ["${aws_security_group.f5.id}"]
  user_data                   = "${data.template_file.f5_init.rendered}"
  key_name                    = "${aws_key_pair.demo.key_name}"
  root_block_device { delete_on_termination = true }

  tags = {
    Name = "${var.prefix}-f5"
    Env  = "consul"
  }

}

data "template_file" "f5_init" {
  template = "${file("../scripts/f5.tpl")}"

  vars = {
    password = "${random_string.password.result}"
  }
}
