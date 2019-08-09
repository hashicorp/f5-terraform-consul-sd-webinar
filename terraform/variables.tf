variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-east-1"
}

variable "availabilty_zone" {
  default = "us-east-1a"
}

variable "instance_type" {
  description = "AWS instance type"
  default = "m4.xlarge"
}
