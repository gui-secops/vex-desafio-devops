resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.projeto}-${var.candidato}-igw"
    }
  )
}