resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = merge(
    var.tags,
    {
      Name = "${var.projeto}-${var.candidato}-subnet"
    }
  )
}