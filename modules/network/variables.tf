variable "tag_terraform-stackid" {
  type        = string
  description = "Tag to append to each resource for the AWS project name"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
}

variable "subnet_cidr" {
  type = string
  description = "Subnet CIDR Block"
}

variable "your_public_ip" {
  type = string
  description = "Your Public IP Address: (X.X.X.X)"
}