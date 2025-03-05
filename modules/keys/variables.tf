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