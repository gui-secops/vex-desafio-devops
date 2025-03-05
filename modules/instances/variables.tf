variable "projeto" {
  description = "Nome do projeto"
  type        = string
  default     = "VExpenses"
}

variable "candidato" {
  description = "Nome do candidato"
  type        = string
  default     = "GuilhermeFranciscoDias"
}

variable "tags" {
  type        = map(any)
  description = "Tags para adicionar nos recursos AWS"
}

variable "main_subnet" {
  description = "Subnet para ser usada EC2"
}

variable "ec2_key_pair" {
  description = "Key Pair para ser usada EC2"
}

variable "main_sg" {
  description = "Security Group para ser usado EC2"
}

variable "main_igw" {
  description = "IGW para ser usado EC2"
}