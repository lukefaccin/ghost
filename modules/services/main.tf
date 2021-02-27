terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

#Configure the Cloudflare provider
provider "cloudflare" {
  email   = var.cf_email
  api_key = var.cf_apikey
}

#Create a DNS record and enable Cloudflare proxying.
resource "cloudflare_record" "www" {
  zone_id = var.cf_zone_id
  name    = "${var.subdomain}"
  value   = var.web_eip
  type    = "A"
  ttl     = 1
  proxied = true
}

#Filter for firewall rule to whitelist your public IP for the admin portal.
resource "cloudflare_filter" "ghost_allow_filter" {
  zone_id = var.cf_zone_id
  description = "Ghost block filter"
  expression = "(http.request.uri contains \"/ghost/\" and ip.src eq ${var.your_public_ip})"
}

#Firewall rule to whitelist your public IP for the admin portal.
resource "cloudflare_firewall_rule" "ghost_allow" {
  zone_id = var.cf_zone_id
  description = "Allow explicit IP Addresses"
  filter_id = cloudflare_filter.ghost_allow_filter.id
  action = "allow"
  priority = 1
}

#Filter for firewall rule to block all traffic to the admin portal.
resource "cloudflare_filter" "ghost_block_filter" {
  zone_id = var.cf_zone_id
  description = "Ghost block filter"
  expression = "(http.request.uri contains \"/ghost/\")"
}

#Firewall rule to block all traffic to the admin portal.
resource "cloudflare_firewall_rule" "ghost_block" {
  zone_id = var.cf_zone_id
  description = "Block Admin Page"
  filter_id = cloudflare_filter.ghost_block_filter.id
  action = "block"
  priority = 2
}

#Create a page rule to exclude the admin portal from Cloudflare cache.
resource "cloudflare_page_rule" "admin_page" {
  zone_id = var.cf_zone_id
  target = "${var.subdomain}.${var.cf_zone}/ghost/*"
  priority = 2
  actions {
    cache_level = "bypass"
  }
}

#Create a page rule to exclude the Let's Encrypt verification path from SSL and Automatic HTTPS Rewrites
resource "cloudflare_page_rule" "lets_encrypt" {
  zone_id = var.cf_zone_id
  target = "${var.subdomain}.${var.cf_zone}/.well-known/acme-challenge/*"
  priority = 1
  actions {
    ssl = "off"
    automatic_https_rewrites = "off"
  }
}

#Create a page rule to redirect root domain to www subdomain.
resource "cloudflare_page_rule" "root_domain_redirect" {
  zone_id = var.cf_zone_id
  target = "${var.cf_zone}/*"
  priority = 3
  actions {
    forwarding_url {
      url = "https://${var.subdomain}.${var.cf_zone}"
      status_code = 301
    }
  }
}