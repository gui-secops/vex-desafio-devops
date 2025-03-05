## SPRINT 2 - Modificação e Melhoria do Código Terraform

**O segundo tópico a ser abordado é o de realizar alterações no código, criar uma automação de um server Nginx, realizar melhorias no código e a descrição técnica**  

### DESCRIÇÃO TÉCNICA

0. Inicialmente foi realizada a criação de módulos diferentes para a infraestrutura. Com isso foram separados os recursos de **network**, **instances** e **keys**. Nessa organização de recursos também foram separados os arquivos de **output** e **variables** dos módulos. Além disso, o **provider** e **region** ganharam arquivos individuais para melhor separação dos diferentes recursos criados. Além dessas mudanças realizadas ao decorrer do código, também foi realizada a adição do arquivo chamado **locals** que definem as tags que serão utilizadas em todos os recursos e que somente acrescentaram a tag individual do próprio recurso. Por fim, o arquivo **main** irá ser responsável por realizar a chamada dos módulos que foram criados.

1. A primeira alteração realizada no código foi a de aumentar o número de RSA de 2048 para 4096 a fim de buscar aumentar o nível de segurança em , por exemplo, casos de ataque de forrça bruta.  

```
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

2. A segunda alteração realizada foi a de criação e armazenamento local do par de chaves SSH para habilitar o acesso seguro aos recursos das instâncias.  

```
resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "./.ssh/terraform_rsa"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ec2_key.public_key_openssh
  filename = "./.ssh/terraform_rsa.pub"
}
```

3. A terceira mudança foi no recurso de **aws_subnet**, adicionando o argumento "map_public_ip_on_launch" com a finalidade de que as instâncias inicializadas nessa subnet devem receber um endereço IP público.  

```
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.projeto}-${var.candidato}-subnet"
    }
  )
}
```

4. A quarta alteração realizada foi a remoção do bloco de atributo "tags" do recurso **aws_route_table_association** pois é um argumento que não está listado nesse recurso.

```
resource "aws_route_table_association" "main_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}
```

5. A quinta alteração foi realizada no recurso **aws_security_group**, onde foi retirado caracteres que estão fora do ASCII, impedindo a execução do código. Além disso, foram adicionados as regras de entrada liberando as portas 443 e 80 para acesso web do servidor.

```
resource "aws_security_group" "main_sg" {
  name        = "${var.projeto}-${var.candidato}-sg"
  description = "Permitir SSH conhecido"
  vpc_id      = aws_vpc.main_vpc.id

  # Regras de entrada
  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] #Ideal utilizar IP fixo
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] #Ideal utilizar IP fixo
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] #Ideal utilizar IP fixo
    ipv6_cidr_blocks = ["::/0"]
  }

  # Regras de saída
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.projeto}-${var.candidato}-sg"
    }
  )
}
```

6. Na sexta alteração, que acontece no recurso de **aws_instance**. A primeira mudança citada é o de que em relação à referência ao grupo de segurança se dá pelo id e não pelo nome. A segunda seria a troca da chamada do "security_groups" pelo "vpc_security_group_ids", pois o mesmo é indicado quando há a criação da instância com uma VPC. A terceira mudança é em relação ao atributo "depends_on", que garante que a criação da instância espere até que os grupos de segurança e internet gateways estejam configurados. Esse atributo garante a comunicação correta com a Internet.  

```
resource "aws_instance" "debian_ec2" {
  ami                    = data.aws_ami.debian12.id
  instance_type          = "t2.micro"
  subnet_id              = var.main_subnet.id
  key_name               = var.ec2_key_pair.key_name
  vpc_security_group_ids = [var.main_sg.id]

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  depends_on = [
    var.main_sg,
    var.main_igw
  ]
}
```

7. A sétima alteração foi realizada no bloco data **user_data**, onde está sendo realizada a criação do servidor Nginx, que foi uma das tarefas solicitadas no documento do desafio. O mesmo foi criado dentro do script importado para a criação do servidor nginx vindo um arquivo separado, buscando melhor segmentação dos arquivos.

```
user_data = file("./scripts/setup-instance.sh")
```

8. Para adicionar uma documentação automatizada ao projeto Terraform, incluí o **terraform-docs** que tem a função de gerar uma documentação com a apresentação dos requerimentos, provedores, inputs e outputs dos módulos do projeto. Com isso, é possível garantir melhor apresentação e organização das características da infraestrutura criada.

### EDIÇÕES FUTURAS E RECURSOS UTILIZADOS

O código elaborado ainda pode passar por melhorias como na implementação de pre-commit hooks. Esse hooks podem garantir diversas melhorias a serem implementadas antes dpo commit do código. Um exemplo é no uso do ```terraform_fmt```, onde o arquivo é totalmente formatado pela indentação do Terraform. Outro exemplo é o ```terraform_validate```, que irá validar os arquivos Terraform usados na infraestrutura.

Fontes utilizadas:  
[Documentação AWS](https://docs.aws.amazon.com/pt_br/)  
[Documentação Terraform - Hashicorp](https://developer.hashicorp.com/terraform/docs)  
[Documentação Terraform - Registry](https://registry.terraform.io/)  
[Documentação Terraform-Docs](https://terraform-docs.io/)

### SERVIDOR EM FUNCIONAMENTO

[Servidor NGINX](https://drive.google.com/file/d/1KZ9R_zGT8iwH5ZFgOkNWE4BC6tOVoSdf/view?usp=sharing)