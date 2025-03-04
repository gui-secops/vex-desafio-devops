#  DESAFIO DEVOPS - VEX  

## Pré-requisitos
* [AWS CLI](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-chap-configure.html) 
* [Terraform](https://developer.hashicorp.com/terraform/install) 

## Comandos

```
//Irá inicializar o diretório de trabalho com arquivos de configuração do Terraform.
terraform init
```
```
//Irá gerar um plano de execução, que conta com os recursos criados, editados ou destruídos no código, de forma anterior a aplicar alterações.
terraform plan
```
```
//Irá aplicar as intruções do código criado e realizar a implantação dos recursos.
terraform apply
```
```
//Irá destruir todos os recursos criados no código Terraform.
terraform destroy
```
## Documentação

### Análise Técnica
Acesso para o arquivo solicitada da [Análise Técnica](https://github.com/gui-secops/vex-desafio-devops/blob/main/documentation/An%C3%A1lise%20T%C3%A9cnica.md)

### Modificações e Melhorias
Acesso para o arquivo solicitada ds [Modificações e Melhorias](https://github.com/gui-secops/vex-desafio-devops/blob/main/documentation/Melhorias.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.89.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_instances"></a> [instances](#module\_instances) | ./modules/instances | n/a |
| <a name="module_keys"></a> [keys](#module\_keys) | ./modules/keys | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_candidato"></a> [candidato](#input\_candidato) | Nome do candidato | `string` | `"GuilhermeFranciscoDias"` | no |
| <a name="input_projeto"></a> [projeto](#input\_projeto) | Nome do projeto | `string` | `"VExpenses"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_candidato"></a> [candidato](#output\_candidato) | Nome do Candidato |
| <a name="output_ec2_public_ip"></a> [ec2\_public\_ip](#output\_ec2\_public\_ip) | Endereço IP público da instância EC2 |
| <a name="output_private_key"></a> [private\_key](#output\_private\_key) | Chave privada para acessar a instância EC2 |
| <a name="output_projeto"></a> [projeto](#output\_projeto) | Nome do Projeto |
<!-- END_TF_DOCS -->