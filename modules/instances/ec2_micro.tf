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

  user_data = file("./scripts/setup-instance.sh")

  tags = merge(
    var.tags,
    {
      Name = "${var.projeto}-${var.candidato}-ec2-micro"
    }
  )
}