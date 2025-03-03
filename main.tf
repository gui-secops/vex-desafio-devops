module "network" {
  source    = "./modules/network"
  projeto   = var.projeto
  candidato = var.candidato
  tags      = local.tags
}

module "intances" {
  source    = "./modules/instances"
  projeto   = var.projeto
  candidato = var.candidato
  tags      = local.tags
}

module "keys" {
  source    = "./modules/keys"
  projeto   = var.projeto
  candidato = var.candidato
  tags      = local.tags
}

output "private_key" {
  description = "Chave privada para acessar a instância EC2"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}

output "ec2_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.debian_ec2.public_ip
}
