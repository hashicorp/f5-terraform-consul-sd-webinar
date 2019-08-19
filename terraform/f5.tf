resource "aws_instance" "F5" {
    ami = "ami-00a9fd893d5d15cf6"
    instance_type = "m5.xlarge"
    private_ip = "10.0.0.200"
    associate_public_ip_address = true
    availability_zone = "${aws_subnet.management.availability_zone}"
    subnet_id = "${aws_subnet.management.id}"
    vpc_security_group_ids = ["${aws_security_group.f5.id}"]
    user_data = "${file("../scripts/f5.sh")}"
    key_name = "${aws_key_pair.demo.key_name}"
    root_block_device { delete_on_termination = true }
    tags {
        Name = "F5"
        Owner = "lance@hashicorp.com"
        TTL   = "-1"
    }
}
