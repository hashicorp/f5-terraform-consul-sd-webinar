resource "aws_instance" "consul" {
    ami = "ami-08b314ce48a790a19" #Ubuntu
    instance_type = "t2.medium"
    associate_public_ip_address = true
    private_ip = "10.0.2.10"
    availability_zone = "${aws_subnet.internal.availability_zone}"
    subnet_id = "${aws_subnet.internal.id}"
    vpc_security_group_ids = ["${aws_security_group.consul.id}"]
    user_data = "${file("../scripts/consul.sh")}"
    key_name = "${aws_key_pair.demo.key_name}"
    tags {
        Name = "Consul"
        Owner = "lance@hashicorp.com"
        TTL   = "-1"
    }
}
