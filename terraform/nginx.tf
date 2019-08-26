data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "nginx" {
  name_prefix   = "nginx-"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = true

  security_groups = ["${aws_security_group.nginx.id}"]
  key_name = "${aws_key_pair.demo.key_name}"
  user_data = "${file("../scripts/nginx.sh")}"

  iam_instance_profile = "${aws_iam_instance_profile.consul.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nginx" {
  name                 = "nginx-asg"
  launch_configuration = "${aws_launch_configuration.nginx.name}"
  min_size             = 3
  max_size             = 5
  vpc_zone_identifier  = ["${module.vpc.public_subnets[0]}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "nginx"
      propagate_at_launch = true
    },
    {
      key                 = "Env"
      value               = "consul"
      propagate_at_launch = true
    },
  ]

}
