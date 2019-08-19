resource "aws_vpc" "abc" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "F5"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.abc.id}"
  tags {
    Name = "default"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.abc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table_association" "route_table_external" {
    subnet_id = "${aws_subnet.external.id}"
    route_table_id = "${aws_vpc.abc.main_route_table_id}"
}

resource "aws_route_table_association" "route_table_internal" {
    subnet_id = "${aws_subnet.internal.id}"
    route_table_id = "${aws_vpc.abc.main_route_table_id}"
}

resource "aws_subnet" "management" {
  vpc_id                  = "${aws_vpc.abc.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.availabilty_zone}"
  tags {
    Name = "management"
  }
}

resource "aws_subnet" "external" {
  vpc_id                  = "${aws_vpc.abc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.availabilty_zone}"
  tags {
    Name = "external"
  }
}

resource "aws_subnet" "internal" {
  vpc_id                  = "${aws_vpc.abc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.availabilty_zone}"
  tags {
    Name = "internal"
  }
}

resource "aws_network_interface" "internal" {
    subnet_id = "${aws_subnet.internal.id}"
    private_ips = ["10.0.2.200"]
    security_groups = ["${aws_security_group.internal_traffic.id}"]
    attachment {
        instance = "${aws_instance.F5.id}"
        device_index = 1
    }
}

resource "aws_network_interface" "external" {
    subnet_id = "${aws_subnet.external.id}"
    private_ips = ["10.0.1.200","10.0.1.202"]
    security_groups = ["${aws_security_group.virtual_server.id}"]
    attachment {
        instance = "${aws_instance.F5.id}"
        device_index = 2
    }
}

resource "aws_eip" "vs_vip" {
  vpc                       = true
  network_interface         = "${aws_network_interface.external.id}"
  associate_with_private_ip = "10.0.1.202"
}

resource "aws_eip" "mgmt_vip" {
  vpc                       = true
  network_interface         = "${aws_instance.F5.primary_network_interface_id}"
  associate_with_private_ip = "10.0.0.200"
}

resource "aws_security_group" "allow_all" {
  name        = "allow all"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.abc.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "f5" {
  name        = "f5"
  vpc_id      = "${aws_vpc.abc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "virtual_server" {
  name        = "virtual server"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.abc.id}"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal_traffic" {
  name        = "internal traffic"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.abc.id}"

  ingress {
    from_port = 4353
    to_port = 4353
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 6699
    to_port = 6699
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 1026
    to_port = 1026
    protocol = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nginx" {
  name        = "nginx"
  vpc_id      = "${aws_vpc.abc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 8300
    to_port = 8300
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 8301
    to_port = 8301
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "consul" {
  name        = "consul"
  vpc_id      = "${aws_vpc.abc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8300
    to_port = 8300
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 8301
    to_port = 8301
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
