# F5 BIG-IP Terraform & Consul Webinar - Zero Touch App Delivery with F5, Terraform & Consul
- This repository will provision BIG-IP VE (Pay as you Grow), Consul & NGNX servers in AWS

# How to use this repo

- Clone the repository 
- Change directory
```
cd f5-terraform-consul-sd-webinar/terraform/

```
- Run terraform plan. terraform apply
- This will create BIG-IP, consul, NGINX instances on AWS

### Folder as3
Folder as3 has three files, main.tf, nginx.json and  variables.tf, main.tf is used to provision nginx.json template to bigip once its ready.
Please download the AS3 rpm module from https://github.com/F5Networks/f5-appsvcs-extension before doing terraform apply.

### Folder scripts
consul.sh is used to install consul 
f5.tpl is used to change the admin password.
nginx.sh is used to install consul agent on nginx servers

### Folder terraform
- This folder has tf files for creating instances for consul, f5, iam policy, nginx servers with autoscale group.
- main.tf refres to what region is used on aws. 
- ssh.tf is used to create the key pairs.
- vpc.tf is used to create a new vpc called f5.vpc and also to define the aws security groups.
- outputs.tf is used to output and display  F5 BIG-IP management IP and F5 BIG-IP dynamic Password 
- To login into F5 BIG-IP using GUI F5_IP displayed,  for example use https://F5_IP:8443 and Passsword as value of F5_Password

### Images used
- BIG-IP image used is 14.1 version
- AS3 rpm used is 3.7.0 version
- HashiCorp & F5 webinar based on https://clouddocs.f5.com/cloud/public/v1/aws/AWS_singleNIC.html

