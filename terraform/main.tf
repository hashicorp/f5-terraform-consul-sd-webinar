provider "aws" {
 region = "us-east-1"
}

resource "random_string" "password" {
  length = 10
  special = false
}
