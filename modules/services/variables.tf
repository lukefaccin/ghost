variable "cf_email"{
  type = string
  description = "CloudFlare Email Address."
}
variable "cf_apikey"{
  type = string
  description = "CloudFlare API Key."
}
variable "cf_zone"{
  type = string
  description = "CloudFlare Zone."
}
variable "cf_zone_id"{
  type = string
  description = "CloudFlare Zone ID."
}
variable "web_eip"{
  type = string
  description = "Elastic IP Address for EC2 Instance."
}
variable "your_public_ip"{
  type = string
  description = "Your Public IP Address: (X.X.X.X)"
}
variable "subdomain" {
  type = string
  description = "Subdomain for your website (Default: 'www'):"
}