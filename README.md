# F5 BIG-IP Terraform & Consul Webinar - Zero Touch App Delivery with F5, Terraform & Consul
- This repository will provision BIG-IP VE (Pay as you Grow), Consul & NGINX servers in AWS

# Demo
You can check out a recording of this demo [here](https://youtu.be/rVTgTXpiopc?t=1489)

# Architecture
![Demo Arch](assets/f5_arch.png)

# How to use this repo

- Clone the repository
- Change directory
```
cd f5-terraform-consul-sd-webinar/terraform/

```
- Run terraform plan. terraform apply
- This will create BIG-IP, consul, NGINX instances on AWS
- Next we need to download and load AS3 rpm into BIG-IP, for AS3 documentation and download please refer to https://github.com/F5Networks/f5-appsvcs-extension
- Once the rpm is installed on BIG-IP change the directory using ```cd f5-terraform-consul-sd-webinar/as3```
- Do terraform plan & apply, this will deploy the AS3 declarative JSON for service discovery on BIG-IP. It will use as3.tf file. You can either edit the example `terraform.tfvars.example` file in that directory to pass the necessary variables to terraform, or enter them manually via the CLI, copying the format of the values in the file. 
- Now you have Virtual IP and Pool information already configured on BIG-IP in partition defined in the consul.json file.

# How to test?
- You can access backend applications using http://VIP_IP:8080 where VIP_IP is the Elastic IP which maps to BIG-IP Private VIP_IP.
- The NGINX servers are already in Auto scale group with consul agents running and sending all information to Consul server.
- Use case is when you destroy or bring down  one of the NGINX server, BIG-IP AS3 will poll the consul server and update the pool members automatically
- So as the NGINX servers are going up and down the BIG-IP Pool members are updated automatically without manual intervention.  

### Folder as3
Folder as3 has three files, main.tf, nginx.json and  variables.tf, main.tf is used to provision nginx.json template to BIG-IP once its ready.
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

### Product Versions
- BIG-IP image used is 14.1 version
- AS3 rpm used is [3.7.0 version](https://github.com/F5Networks/f5-appsvcs-extension/raw/v3.7.0/dist/latest/f5-appsvcs-3.7.0-7.noarch.rpm)
- HashiCorp & F5 webinar based on https://clouddocs.f5.com/cloud/public/v1/aws/AWS_singleNIC.html
