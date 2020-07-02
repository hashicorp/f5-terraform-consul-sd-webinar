resource "aws_iam_role_policy" "consul" {
  name = "${var.prefix}-f5-consul-policy"
  role = "${aws_iam_role.consul.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeTags",
        "autoscaling:DescribeAutoScalingGroups"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "consul" {
  name = "${var.prefix}-f5-consul-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "consul" {
  name = "${var.prefix}-consul_sd"
  role = "${aws_iam_role.consul.name}"
}

resource "aws_iam_role_policy" "bigip" {
  name = "${var.prefix}-f5-bigip-policy"
  role = "${aws_iam_role.bigip.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:DeleteObject"	
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/admin.shadow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "bigip" {
  name = "${var.prefix}-f5-bigip-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bigip" {
  name = "${var.prefix}-bigip"
  role = "${aws_iam_role.bigip.name}"
}
