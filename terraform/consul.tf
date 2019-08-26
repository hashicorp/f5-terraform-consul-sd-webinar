resource "aws_instance" "consul" {
    ami = "ami-08b314ce48a790a19" #Ubuntu
    instance_type = "m5.large"
    associate_public_ip_address = true
    private_ip = "10.0.0.100"
    subnet_id = "${module.vpc.public_subnets[0]}"
    vpc_security_group_ids = ["${aws_security_group.consul.id}"]
    user_data = "${file("../scripts/consul.sh")}"
    iam_instance_profile = "${aws_iam_instance_profile.consul.name}"
    key_name = "${aws_key_pair.demo.key_name}"
    tags {
        Name = "consul"
        Env  = "consul"
    }
}
