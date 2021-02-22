terraform {
  required_version = ">= 0.14.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Create a VPC
resource "aws_vpc" "main" {
  cidr_block  = var.vpc_cidr
  tags        = {
    "terraform:stackid" = var.tag_terraform-stackid
  }
}

#Create a subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id 
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  tags                    = {
    "terraform:stackid" = var.tag_terraform-stackid
  }
}

#Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id  = aws_vpc.main.id
  tags    = {
    "terraform:stackid" = var.tag_terraform-stackid
  }
}

#Create a Route Table
resource "aws_route_table" "main" {
  vpc_id  = aws_vpc.main.id
  tags    = {
    "terraform:stackid" = var.tag_terraform-stackid
  }
}

#Link the Subnet to the Route Table
resource "aws_route_table_association" "subnet" {
  subnet_id       = aws_subnet.main.id
  route_table_id  = aws_route_table.main.id
}

#Add a default route so traffic destined for the internet knows where to go.
resource "aws_route" "default" {
  route_table_id          = aws_route_table.main.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.main.id
}

#Create a Security Group
resource "aws_security_group" "web" {
  vpc_id  = aws_vpc.main.id
  tags    = {
    "terraform:stackid" = var.tag_terraform-stackid
  }
}

#Create a Security Group Rule to allow SSH traffic from your public IP.
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.your_public_ip}/32"]
  security_group_id = aws_security_group.web.id
}

#Pre-seed CloudFlare's IPv4 and IPv6 addresses so website can load successfully. 
#Make sure ranges are up to date for initial deployment: 
#https://api.cloudflare.com/client/v4/ips 
resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["173.245.48.0/20","103.21.244.0/22","103.22.200.0/22","103.31.4.0/22","141.101.64.0/18","108.162.192.0/18","190.93.240.0/20","188.114.96.0/20","197.234.240.0/22","198.41.128.0/17","162.158.0.0/15","104.16.0.0/12","172.64.0.0/13","131.0.72.0/22"]
  ipv6_cidr_blocks  = [ "2400:cb00::/32","2606:4700::/32","2803:f800::/32","2405:b500::/32","2405:8100::/32","2a06:98c0::/29","2c0f:f248::/32" ]
  security_group_id = aws_security_group.web.id
}

#Pre-seed CloudFlare's IPv4 and IPv6 addresses so Let's Encrypt can reach the server. 
#Make sure ranges are up to date for initial deployment: 
#https://api.cloudflare.com/client/v4/ips
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["173.245.48.0/20","103.21.244.0/22","103.22.200.0/22","103.31.4.0/22","141.101.64.0/18","108.162.192.0/18","190.93.240.0/20","188.114.96.0/20","197.234.240.0/22","198.41.128.0/17","162.158.0.0/15","104.16.0.0/12","172.64.0.0/13","131.0.72.0/22"]
  ipv6_cidr_blocks  = [ "2400:cb00::/32","2606:4700::/32","2803:f800::/32","2405:b500::/32","2405:8100::/32","2a06:98c0::/29","2c0f:f248::/32" ]
  security_group_id = aws_security_group.web.id
}

#Create a Security Group Rule to allow all outbound traffic for your server.
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

