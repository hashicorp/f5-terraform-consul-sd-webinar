resource "aws_instance" "nginx" {
    count = "${var.server_count}"

    ami = "ami-08b314ce48a790a19" #Ubuntu
    instance_type = "t2.micro"
    associate_public_ip_address = true
    availability_zone = "${aws_subnet.internal.availability_zone}"
    subnet_id = "${aws_subnet.internal.id}"
    vpc_security_group_ids = ["${aws_security_group.nginx.id}"]
    key_name = "${aws_key_pair.demo.key_name}"
    user_data = "${file("../scripts/nginx.sh")}"
    tags {
        Name = "Nginx"
        Owner = "lance@hashicorp.com"
        TTL   = "-1"
    }
}
