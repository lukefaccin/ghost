output "subnet_id" {
  value = aws_subnet.main.id
}
output "web_secgroup_id" {
  value = aws_security_group.web.id
}
