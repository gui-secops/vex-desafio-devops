module "network" {
  source    = "./modules/network"
  projeto   = var.projeto
  candidato = var.candidato
  tags      = local.tags
}

module "instances" {
  source       = "./modules/instances"
  projeto      = var.projeto
  candidato    = var.candidato
  tags         = local.tags
  main_subnet  = module.network.main_subnet
  ec2_key_pair = module.keys.ec2_key_pair
  main_sg      = module.network.main_sg
}

module "keys" {
  source    = "./modules/keys"
  projeto   = var.projeto
  candidato = var.candidato
  tags      = local.tags
}

output "projeto" {
  description = "Nome do Projeto"
  value       = var.projeto
}

output "candidato" {
  description = "Nome do Candidato"
  value       = var.candidato
}

output "private_key" {
  description = "Chave privada para acessar a instância EC2"
  value       = module.keys.ec2_key.private_key_pem
  sensitive   = true
}

output "ec2_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = module.instances.debian_ec2.public_ip
}