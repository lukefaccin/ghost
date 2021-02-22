variable "tag_terraform-stackid" {
  type = string
  description = "Tag to append to each resource for the AWS project name"
}

variable "instance_type" {
  type = string
  description = "EC2 Instance Type"
}

variable "subnet_id"{
  type = string
  description = "Subnet ID injected from the network module."
}

variable "web_secgroup_id"{
  type = string
  description = "Security Group ID injected from the network module."
}

variable "ec2_keypair"{
  type = string
  description = "Your public key pair for SSH connectivity to EC2"
}

variable "cf_zone" {
  type = string
  description = "Your DNS Zone in CloudFlare (e.g. lukefaccin.com)"
}

variable "db_name" {
  type = string
  description = "The database name."
}
variable "db_pass" {
  type = string
  description = "The database root password."
}

variable "ssl_email" {
  type = string
  description = "The email address for monitoring certificate renewal alerts:" 
}
variable "sys_username" {
  type = string
  description = "Root admin system username:"
}
variable "subdomain" {
  type = string
  description = "Subdomain for your website (Default: 'www'):"
}