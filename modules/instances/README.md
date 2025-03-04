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
| [aws_instance.debian_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.debian12](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_candidato"></a> [candidato](#input\_candidato) | Nome do candidato | `string` | `"GuilhermeFranciscoDias"` | no |
| <a name="input_ec2_key_pair"></a> [ec2\_key\_pair](#input\_ec2\_key\_pair) | Key Pair to be used in EC2 | `any` | n/a | yes |
| <a name="input_main_igw"></a> [main\_igw](#input\_main\_igw) | IGW to be used in EC2 | `any` | n/a | yes |
| <a name="input_main_sg"></a> [main\_sg](#input\_main\_sg) | Security Group to be used in EC2 | `any` | n/a | yes |
| <a name="input_main_subnet"></a> [main\_subnet](#input\_main\_subnet) | Subnet to be used in EC2 | `any` | n/a | yes |
| <a name="input_projeto"></a> [projeto](#input\_projeto) | Nome do projeto | `string` | `"VExpenses"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be added to AWS resources | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_debian_ec2"></a> [debian\_ec2](#output\_debian\_ec2) | instância EC2 |
<!-- END_TF_DOCS -->