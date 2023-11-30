# VPC
resource "aws_vpc" "fp_vpc" {
  cidr_block = var.cidr_block
  tags = merge(var.default_tags, tomap({
    Name = var.name
  }))
}


# Public Subnets
module "fp_public_subnets" {
  source       = "../subnet"
  vpc_id       = aws_vpc.fp_vpc.id
  subnets      = var.public_subnets
  visibility   = "Public"
  default_tags = var.default_tags
}

# Private Subnets
module "fp_private_subnets" {
  source       = "../subnet"
  vpc_id       = aws_vpc.fp_vpc.id
  subnets      = var.private_subnets
  visibility   = "Private"
  default_tags = var.default_tags
}

resource "aws_internet_gateway" "fp_igw" {
  vpc_id = aws_vpc.fp_vpc.id
  tags = merge(var.default_tags, tomap({
    Name = "${var.name}-igw"
  }))
}

resource "aws_eip" "fp_nat_eip" {
  tags = merge(var.default_tags, tomap({
    Name = "${var.name}-eip"
  }))
}

resource "aws_nat_gateway" "fp_nat" {
  subnet_id     = var.nat_subnet_id
  allocation_id = aws_eip.fp_nat_eip.id
  tags = merge(var.default_tags, tomap({
    Name = "${var.name}-nat"
  }))
}
