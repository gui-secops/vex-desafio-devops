output "ec2_key" {
  description = "Key da instância EC2"
  value       = tls_private_key.ec2_key
}

output "ec2_key_pair" {
  description = "Par de chaves da instância EC2"
  value       = aws_key_pair.ec2_key_pair
}