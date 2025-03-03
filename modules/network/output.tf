output "main_sg" {
  description = "Grupo de Segurança"
  value       = aws_security_group.main_sg
}

output "main_vpc" {
  description = "VPC"
  value       = aws_security_group.main_vpc
}

output "main_subnet" {
  description = "Subnet"
  value       = aws_security_group.main_subnet
}