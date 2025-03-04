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
  description = "Tags to be added to AWS resources"
}

variable "main_subnet" {
  description = "Subnet to be used in EC2"
}

variable "ec2_key_pair" {
  description = "Key Pair to be used in EC2"
}

variable "main_sg" {
  description = "Security Group to be used in EC2"
}

variable "main_igw" {
  description = "IGW to be used in EC2"
}