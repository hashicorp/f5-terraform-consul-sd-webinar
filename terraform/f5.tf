resource "random_string" "password" {
  length  = 10
  special = false
}

# encrypt password sha512
resource "null_resource" "admin-shadow" {
  provisioner "local-exec" {
    command = "./admin-shadow.sh ${random_string.password.result}"
  }
}

data "template_file" "f5_init" {
  template = file("../scripts/f5.tpl")

  vars = {
    encrypted_password = chomp(file("admin.shadow"))
  }
  depends_on = [null_resource.admin-shadow]
}

module "bigip" {
  count                  = 1
  source                 = "git::https://github.com/f5devcentral/terraform-aws-bigip-module?ref=0.9"
  prefix                 = "${var.prefix}-f5-bigip"
  ec2_instance_type      = "m5.large"
  ec2_key_name           = aws_key_pair.demo.key_name
  f5_ami_search_name     = var.f5_ami_search_name
  f5_username            = var.f5_username
  mgmt_subnet_ids        = [{ "subnet_id" = module.vpc.public_subnets[0], "public_ip" = true, "private_ip_primary" = "10.0.0.200" }]
  mgmt_securitygroup_ids = [aws_security_group.f5.id]
  custom_user_data       = data.template_file.f5_init.rendered
}
