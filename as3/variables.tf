variable "address" {}
variable "port" {}
variable "username" {}
variable "password" {}
variable "as3_rpm" {
  default = "f5-appsvcs-3.7.0-7.noarch.rpm"
}
variable "as3_rpm_url" {
  default = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.7.0/f5-appsvcs-3.7.0-7.noarch.rpm"
}
