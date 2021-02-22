variable "aws_profile" {
  type = string
  description = "The name of the AWS Profile to use from your machine:"
  default = "default"
}

variable "aws_region" {
  type = string
  description = "The AWS Region (e.g. us-east-2, ap-southeast-2):"
  default = "us-east-2"
}

variable "tag_terraform-stackid" {
  type = string
  description = "The AWS resource tag applied to resources in this deployment:"
  default = "blog"
}

variable "ec2_keypair" {
  type = string
  description = "Your public key for SSH connectivity to EC2 (e.g. sha-rsa...):"
  default = "sha-rsa YourKey"
}

variable "cf_email"{
  type = string
  description = "Your Cloudflare email address:"
  sensitive = true
  default = ""
}
variable "cf_apikey"{
  type = string
  description = "Your Cloudflare API Key:"
  sensitive = true
  default = ""
}
variable "cf_zone_id"{
  type = string
  description = "CloudFlare Zone ID for the domain name:"
  default = ""
}
variable "cf_zone"{
  type = string
  description = "Domain name located in CloudFlare (e.g. lukefaccin.com):"
  default = ""
}

variable "instance_size" {
  type = string
  description = "Type of EC2 Instance (e.g. t3a.micro, t3a.small, t3.micro):"
  default = "t3a.micro"
}

variable "db_pass" {
  type = string
  sensitive = true
  description = "Set a new password for the root database user. Note: Ghost will temporarily use these credentials to create its database and own user account to use going forward:"
  default = ""
}
variable "db_name" {
  type = string
  description = "Name of the new database that Ghost will use:"
  default = "website_prod"
}
variable "ssl_email" {
  type = string
  sensitive = true
  description = "Email address to receive Let's Encrypt expiry notifications:"
  default = ""
}

variable "your_public_ip" {
  type = string
  description = "Your Public IP Address: (X.X.X.X)"
  default = ""
}

variable "subdomain" {
  type = string
  description = "Subdomain for your website (Default: 'www'):"
  default = "www"
}

variable "sys_username" {
  type = string
  description = "Username for the account:"
  default = "ubuntu"
}

variable "vpc_cidr" {
  type = string
  description = "Network block for your VPC in CIDR format (X.X.X.X/XX):"
  default = "10.10.0.0/16"
}
variable "subnet_cidr" {
  type = string
  description = "Network block for the subnet within the VPC in CIDR format (X.X.X.X/XX):"
  default = "10.10.10.0/24"
}