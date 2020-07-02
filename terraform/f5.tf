resource "random_string" "password" {
  length  = 10
  special = false
}

data "aws_ami" "f5_ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["${var.f5_ami_search_name}"]
  }
}

resource "aws_instance" "f5" {

  ami = "${data.aws_ami.f5_ami.id}"
  instance_type               = "m5.xlarge"
  private_ip                  = "10.0.0.200"
  associate_public_ip_address = true
  subnet_id                   = "${module.vpc.public_subnets[0]}"
  vpc_security_group_ids      = ["${aws_security_group.f5.id}"]
  user_data                   = "${data.template_file.f5_init.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.bigip.name}"
  key_name                    = "${aws_key_pair.demo.key_name}"
  root_block_device { delete_on_termination = true }

  tags = {
    Name = "${var.prefix}-f5-bigip"
    Env  = "consul"
  }

}


resource "aws_s3_bucket" "s3_bucket" {
  bucket_prefix = "${var.prefix}-s3bucket"
}
# encrypt password sha512
resource "null_resource" "admin-shadow" {
  provisioner "local-exec" {
    command = "./admin-shadow.sh ${random_string.password.result}"
  }
}

resource "aws_s3_bucket_object" "password" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"
  key = "admin.shadow"
  source = "admin.shadow"
  depends_on = ["null_resource.admin-shadow"]
}

data "template_file" "f5_init" {
  template = "${file("../scripts/f5.tpl")}"

  vars = {
#    password = "${random_string.password.result}"
    s3_bucket = "${aws_s3_bucket.s3_bucket.id}"
  }
}
