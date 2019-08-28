# F5 BIG-IP Terraform & Consul Webinar - Zero Touch App Delivery with F5, Terraform & Consul
- This repository will provision BIG-IP VE (Pay as you Grow), Consul & ngnx servers in AWS

# How to use this repo

- Clone the repository 
- Change directory
```
cd f5-terraform-consul-sd-webinar/terraform/

```
- Run terraform plan. terraform apply
- This will create BIG-IP, consul, nginx instances on AWS

### Folder as3
Folder as3 has three files, main.tf, nginx.json and  variables.tf, main.tf is used to provision nginx.json template to bigip once its ready.

### Folder scripts
consul.sh is used to install consul 
f5.tpl is used to change the admin password.
nginx.sh is used to install consul agent on nginx servers

### Folder terraform
This folder has tf files for creating instances for consul, f5, iam policy, nginx servers with autoscale group. main.tf refres to what region is used on aws. ssh.tf is used to create the key pairs. vpc.tf is used to create a new vpc called f5.vpc and also to define the aws security groups. outputs.tf is used to out put the f5 management IP and inorder to login into BIG-IP please use value of public IP displayed for example use https://x.x.x.x:8443, if you want to login into the BIG-IP from browser.
output.tf also displays the f5_password value which you can use to login, so to login use admin and password will be displayed value of F5_Password.

HashiCorp & F5 webinar based on https://clouddocs.f5.com/cloud/public/v1/aws/AWS_singleNIC.html
