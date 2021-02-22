provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

#Build the network as per the network module.
module network{
  source                = "./modules/network"
  tag_terraform-stackid = var.tag_terraform-stackid
  vpc_cidr              = var.vpc_cidr
  subnet_cidr           = var.subnet_cidr
  your_public_ip        = var.your_public_ip
}

#Build the server as per the server module.
module server{
  source                = "./modules/server"
  tag_terraform-stackid = var.tag_terraform-stackid
  instance_type         = var.instance_size
  subnet_id             = module.network.subnet_id
  web_secgroup_id       = module.network.web_secgroup_id
  ec2_keypair           = var.ec2_keypair
  cf_zone               = var.cf_zone
  db_name               = var.db_name
  db_pass               = var.db_pass
  ssl_email             = var.ssl_email
  sys_username          = var.sys_username
  subdomain             = var.subdomain
}

#Build the services as per the services module.
module services{
  source          = "./modules/services"
  cf_email        = var.cf_email
  cf_apikey       = var.cf_apikey
  cf_zone         = var.cf_zone
  cf_zone_id      = var.cf_zone_id
  web_eip         = module.server.web_eip
  subdomain       = var.subdomain
  your_public_ip  = var.your_public_ip
}
