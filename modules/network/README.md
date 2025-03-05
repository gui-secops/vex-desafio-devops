<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.main_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.main_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.main_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.main_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.main_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_candidato"></a> [candidato](#input\_candidato) | Nome do candidato | `string` | `"GuilhermeFranciscoDias"` | no |
| <a name="input_projeto"></a> [projeto](#input\_projeto) | Nome do projeto | `string` | `"VExpenses"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags para adicionar nos recursos AWS | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main_igw"></a> [main\_igw](#output\_main\_igw) | IGW |
| <a name="output_main_sg"></a> [main\_sg](#output\_main\_sg) | Grupo de Segurança |
| <a name="output_main_subnet"></a> [main\_subnet](#output\_main\_subnet) | Subnet |
| <a name="output_main_vpc"></a> [main\_vpc](#output\_main\_vpc) | VPC |
<!-- END_TF_DOCS -->