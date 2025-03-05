## SPRINT 1 - Análise Técnica do Código Terraform

**O primeiro tópico a ser abordado é o da leitura, descrição técnica e observações do arquivo main.tf enviado aos candidatos.**  


### DESCRIÇÃO TÉCNICA

No início do código Terraform são definidos o **"provider"** e duas **"variables"**.  

O bloco de **provider** possui a definição do provedor e da região a ser utilizada para criação dos recursos, no caso, são o provedor AWS e a região de "us-east-1". Essa primeira configuração é quem define os trilhos dos demais blocos de recursos.  

No bloco de **variables** são definidas as descrições, tipos e os conteúdos padrões, no caso, do projeto e nome do usuário a serem apresentados nelas. Essas variáveis irão ser reutilizadas durante o código e possuem a função de não haver a necessidade de realizar diversas trocas de nomes pelo código e sim em um único ponto. Seu uso também será muito reaproveitado para a criação das tags em cada recurso, como poderá ser observado durante a documentação.

```
provider "aws" {
  region = "us-east-1"
}

variable "projeto" {
  description = "Nome do projeto"
  type        = string
  default     = "VExpenses"
}

variable "candidato" {
  description = "Nome do candidato"
  type        = string
  default     = "SeuNome"
}
```  

Os dois primeiros blocos de recurso definidos são os de **tls_private_key** e **aws_key_pair**.  

O **tls_private_key** tem a funcionalidade de gerar uma chave privada nos formatos PEM ou OpenSSH. Sua utilidade é gerenciar as chaves com certo nível de segurança. Porém, é recomendado ser criado fora do Terraform de produção e utilizado com maior segurança por não haver criptografia no arquivo de estado do Terraform (.tfstate). No exemplo criado, é utilizado o tipo de algoritmo como RSA e o seu rsa_bits em 2048, que faz referência ao tamanho de bits da chave RSA.  

Já o recurso **aws_key_pair** tem como função a criação de um par de chaves que tem a função de controlar o acesso às instâncias EC2. No caso dessa criação, estão sendo usados os argumentos para nomear o par de chaves com as duas variáveis criadas no início, ``key_name = "${var.projeto}-${var.candidato}-key"`` e também o argumento da chave pública extraído pelo Terraform a partir do **tls_private_key** criado anteriormente. Gerando o argumento ``public_key = tls_private_key.ec2_key.public_key_openssh``, a partir da **tls_private_key**,  especificando o nome dado anteriormente ao recurso **ec2_key** e gerando a partir do argumento **public_key_openssh** a chave pública.  

```
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.projeto}-${var.candidato}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}
```  

O terceiro bloco de recurso criado é o de **aws_vcp**, a sua função é a de gerar uma Virtual Private Cloud (VPC), que é o provisionamento de uma parte da AWS isolada onde se pode executar recursos da AWS com a definição do próprio criador dela. Ela é útil para definição de intervalos de IP, sub-redes, tabelas de roteamento, gateways de rede e entre outros recursos que geram configurações de rede e definições de segurança. 

No caso da definição do recurso, é criado um block CIDR ``cidr_block = "10.0.0.0/16"``, que define o intervalo de endereços IP que essa VPC irá possuir. O valor definido de 10.0.0.0/16 irá fornecer o range de 10.0.0.0 - 10.255.255.255 que irá dar um total de 65.536 endereços.  
Os dois próximos argumentos gerados são os de ``enable_dns_support = true`` e ``enable_dns_hostnames = true``. Os dois têm a função, respectivamente, de habilitar o suporte para DNS e hostnames DNS na VPC, com isso permitindo à VPC resolver DNS para endereços IP e, além do endereço IP, receber um hostname DNS. Vale lembrar que essa definição como true é necessária, pois é feita com valores booleanos e por padrão possuem o atributo como falso.  

```
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.projeto}-${var.candidato}-vpc"
  }
}
```  

Os dois blocos de recurso criados a seguir são os de **aws_subnet** e **aws_internet_gateway** onde serão criadas a sub-rede e o gateway de rede.  

O **aws_subnet** tem a função de realizar uma segmentação dentro da **aws_vpc** criada anteriormente. Essa segmentação garante a partilha do bloco CIDR criado anteriormente em partes menores, permitindo ter mais controle de organização e segurança dos recursos criados. No exemplo dado, a sub-rede criada é a ``cidr_block = "10.0.1.0/24"``. Além disso, é criada a zona de disponibilidade, que será onde se encontra a sub-net, que no caso é a ``availability_zone = "us-east-1a"``, que define a região de Norte da Virgínia. Além disso, é necessário realizar o apontamento para a VPC criada, que no caso se dá pelo ``vpc_id = aws_vpc.main_vpc.id`` que faz referência ao recurso "aws_vpc" criado, o nome do recurso dela "vpc_main" e o seu "id".  

Já o **aws_internet_gateway** tem como função garantir que os recursos da sub-rede da VPC possuam conectividade com a internet, tanto de entrada quanto de saída. Além disso, ele fornece uma tabela de rotas da VPC com tráfego com roteamento para a Internet.
Neste caso, também é necessário realizar o apontamento para a VPC criada anteriormente através do ``vpc_id = aws_vpc.main_vpc.id`` que faz a referência criada.  

```
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.projeto}-${var.candidato}-subnet"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.projeto}-${var.candidato}-igw"
  }
}
```  

O sexto e sétimo blocos de recursos criados são os de **aws_route_table** e **aws_route_table_association**. Eles serão responsáveis pelas tabelas de roteamento para a internet.  

O **aws_route_table** é responsável pela criação da tabela de rota padrão que irá direcionar todo o tráfego para o gateway de rede criado anteriormente. Para isso é criado o argumento de "route" que irá receber os argumentos de ``cidr_block = "0.0.0.0/0"`` e ``gateway_id = aws_internet_gateway.main_igw.id``, com essa definição todo o tráfego irá passar pelo internet gateway criado anteriormente através da sua referência pelo recurso, seu nome e seu id.  

Já o **aws_route_table_association** terá como função criar uma associação entre recursos, no caso do exemplo, entre a subnet e a route table garantindo que a subnet use a route table que irá direcionar o tráfego para acessar a Internet. Essa associação é criada através dos argumentos de ``subnet_id = aws_subnet.main_subnet.id`` e ``route_table_id = aws_route_table.main_route_table.id`` que fazem referência, respectivamente, ao recurso da subnet, seu nome e sua id, e também do recurso da route table, seu nome e sua id.


```
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-route_table"
  }
}

resource "aws_route_table_association" "main_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id

  tags = {
    Name = "${var.projeto}-${var.candidato}-route_table_association"
  }
}
```  

O oitavo recurso criado é o de **aws_security_group**, ele possui a responsabilidade de controlar o tráfego que possui a permissão para acessar e sair dos recursos aos quais ele possui associação.  

No caso da definição do exemplo, é dado o nome ao security group através  das variáveis definidas no início do código ``name = "${var.projeto}-${var.candidato}-sg"``, além disso, ele também possui uma descrição e a referência a VPC criada anteriormente através dos respectivos códigos: ``description = "Permitir SSH de qualquer lugar e todo o tráfego de saída" `` e ``vpc_id = aws_vpc.main_vpc.id``.  
O próximo passo é a definição das regras de entrada (ingress). A mesma é feita pelo argumento de "ingress" que irá receber os parâmetros ``description, from_port, to_port, protocol, cidr_blocks, e ipv6_cidr_blocks``. Esses parâmetros possuem, respectivamente, a função de: dar uma descrição das regras de entrada, de qual porta o tráfego inicia, de qual port o tráfego finaliza, o protocolo de rede, permissão de tráfego IPv4 e permissão de tráfego IPv6. No exemplo dado, é realizada a configuração do protocolo SSH e da sua porta 22 além de todos os tráfegos IPv4 e IPv6 atráves, respectivamente, do "0.0.0.0/0" e ::/0, que permitem entrada de qualquer lugar.  
Posteriormente, também são definidas as regras de saída (egress). Essa regra é criada pelo argumento "egress" que também recebe os parâmetros definidos na regra de entrada. No caso do exemplo, é definido que qualquer protocolo de rede através do "-1" que é semanticamente equivalente ao "all", além disso, também é as portas como 0 para aceitarem qualquer uma delas e por fim também são definidos os IPv4 e IPv6 como "0.0.0.0/0" e ::/0, para permitir a saída para qualquer lugar.

```
resource "aws_security_group" "main_sg" {
  name        = "${var.projeto}-${var.candidato}-sg"
  description = "Permitir SSH de qualquer lugar e todo o tráfego de saída"
  vpc_id      = aws_vpc.main_vpc.id

  # Regras de entrada
  ingress {
    description      = "Allow SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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

  tags = {
    Name = "${var.projeto}-${var.candidato}-sg"
  }
}
```  

O último recurso a ser criado é o da instância através do **aws_instance** que é um serviço que fornece a capacidade computacional com redimensionamento na nuvem. Porém, antes da criação da instância EC2, é realizada a busca de uma Amazon Machine Image (AMI) mais recente e que esteja dentro dos critérios determinados para ser utilizada na criação da instância. Essa busca se dá pela fonte de dados **aws_ami**.  

No exemplo dado, é realizada a busca de um Linux Debian 12 com o argumento de ``most_recent = true``, que garante que caso haja mais de um resultado retornado, ele puxe o mais recente. Além disso, são criados dois blocos de argumentos com filtros. O primeiro é o de "name" com o ``values = ["debian-12-amd64-*"]`` que restringe a busca por nomes de AMIs com a correspondência solicitada. O segundo filtro é o de "virtualization-type" com o ``values = ["hvm"]`` que irá restringir a busca por AMIs que suportem a virtualização por hardware.  Além disso, a busca possui também o argumento de "owners" que irá limitar a pesquisa por um ID de conta AWS, no caso o ``owners = ["679593333241"]`` que irá pesquisar por AMIs disponíveis no Marktplace da AWS.

Com a etapa da busca pela AMI realizada, se pode criar a instância com o recurso **aws_instance**. Para a sua criação são utilizados os valores de: ``ami, instance_type, subnet_id, key_name, security_groups, associate_public_ip_address, user_data e root_block_device``, este último sendo um bloco com argumentos.  
A definição do "ami" se dá pela referência do data source criado anteriormente, puxando o seu recurso, nome e id ``ami = data.aws_ami.debian12.id``. O próximo passo é o de tipo da instância, que no caso, é definido a t2.micro que é declarado como ``instance_type = "t2.micro"``.  
Os blocos de "subnet_id", "key_name" e "security_groups" fazem a sua chamado pelo recurso, nome e id (ou nome). As suas declarações, respectivamente são: ``subnet_id = aws_subnet.main_subnet.id``, ``key_name = aws_key_pair.ec2_key_pair.key_name`` e ``security_groups = [aws_security_group.main_sg.name]``. A definição do próximo argumento ``associate_public_ip_address = true`` garante que a instância EC2 possua um endereço IP público.
O bloco de argumentos "root_block_device", garante determinadas ações do volume de armazenamento. No exemplo dado, é definido um volume de 20GB, do tipo gp2 e com a destruição do volume no término da instância.  
Por fim, há o bloco "user_data" que é utilizada para passar comandos que irão ser executados quando a instância for iniciada pela primeira vez. No caso do exemplo, há um script para ser executado com Shell Script e os comandos de update e upgrade que irão atualizar e instalar as versões mais recentes dos pacotes. Com isso, há a garantia de que a instância, ao ser executada pela primeira vez, terá todos os pacotes mais recentes.

```
data "aws_ami" "debian12" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_instance" "debian_ec2" {
  ami             = data.aws_ami.debian12.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.main_subnet.id
  key_name        = aws_key_pair.ec2_key_pair.key_name
  security_groups = [aws_security_group.main_sg.name]

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
              EOF

  tags = {
    Name = "${var.projeto}-${var.candidato}-ec2"
  }
}
```

No fim do código, ainda há dois "outputs" que disponibilizam informações sobra a infraestrutura na CLI.  
O primeiro output é o de ``value = tls_private_key.ec2_key.private_key_pem`` que retorna o valor da chave private, porém possui também o atributo de ``sensitive = true`` que irá ocultar o valor.
Já o segundo output é o de ``value  = aws_instance.debian_ec2.public_ip`` que irá retornar o valor do endereço IP público da instância EC2 criada.  

```
output "private_key" {
  description = "Chave privada para acessar a instância EC2"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}

output "ec2_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.debian_ec2.public_ip
}
```

### OBSERVAÇÕES

1. No recurso **aws_route_table_association** há a criação do bloco de argumento de "tags", porém esse atributo não pode ser criado nesse recurso.
2. Há o uso de caracteres ASCII não suportados durante a criação do **aws_security_group**, sendo o problema o uso de acentuação.
3. Na criação da **aws_instance** há um erro no argumento de "security_groups" que está fazendo a chamado pelo "name" e o correto seria pelo "id".