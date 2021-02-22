terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Automatic Server Build Script
locals {
  userDataScript = <<EOF
#cloud-config
system_info:
  default_user:
    name: ${var.sys_username}
repo_update: true
repo_upgrade: all

runcmd:
  - export PATH=$PATH:/usr/local/bin
  - apt-get update
  - apt-get upgrade -y
  - apt-get install nginx -y
  - ufw allow 'Nginx Full'
  - apt-get install mysql-server -y
  - mysql --host="localhost" --user="root" --execute="ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${var.db_pass}';"
  - curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash
  - apt-get install -y nodejs
  - npm install ghost-cli@latest -g
  - mkdir -p /var/www/${var.cf_zone}
  - chown ${var.sys_username}:${var.sys_username} /var/www/${var.cf_zone}
  - chmod 775 /var/www/${var.cf_zone}
  - sudo su ${var.sys_username} --command "cd /var/www/${var.cf_zone} && ghost install"
  - sudo su ${var.sys_username} --command "cd /var/www/${var.cf_zone} && ghost setup --url '${var.subdomain}.${var.cf_zone}' --sslemail '${var.ssl_email}' --db 'mysql' --dbhost 'localhost' --dbuser 'root' --dbpass '${var.db_pass}' --dbname '${var.db_name}'"
  - sudo su ${var.sys_username} --command "cd /var/www/${var.cf_zone} && ghost start"
EOF
}

#Search the AMI list for Ubuntu 20.04 Server
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] #Filter by Ubuntu 20.04 Server
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical (Creators of Ubuntu)
}

#Create an AWS EC2 Keypair with your public SSH key.
resource "aws_key_pair" "ec2_keypair" {
  key_name   = "ec2-keypair"
  public_key = var.ec2_keypair
}

#Create a network interface for the EC2 Instance
resource "aws_network_interface" "eth0" {
  subnet_id       = var.subnet_id
  security_groups = [var.web_secgroup_id]
}

#Create the EC2 Instance
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = "ec2-keypair"
  user_data_base64 = base64encode(local.userDataScript)
  network_interface {
    network_interface_id = aws_network_interface.eth0.id
    device_index         = 0
  }
  tags = {
    "terraform:stackid" = var.tag_terraform-stackid
  }
}

#Elastic IP Address for EC2 Instance
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  vpc      = true
}