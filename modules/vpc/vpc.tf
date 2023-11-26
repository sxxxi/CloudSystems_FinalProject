# VPC
resource "aws_vpc" "fp_vpc" {
  cidr_block = var.cidr_block

  tags = merge(var.default_tags, tomap({
    Name = var.name
  }))
}


# Public Subnets
module "fp_public_subnets" {
  source = "../subnet"
  vpc_id = aws_vpc.fp_vpc.id
  subnets = var.public_subnets
  visibility = "Public"
  default_tags = var.default_tags
}

# Private Subnets
module "fp_private_subnets" {
  source = "../subnet"
  vpc_id = aws_vpc.fp_vpc.id
  subnets = var.private_subnets
  visibility = "Private"
  default_tags = var.default_tags
}

resource "aws_internet_gateway" "fp_igw" {
  vpc_id = aws_vpc.fp_vpc.id
  count = var.attach_igw ? 1 : 0
}

resource "aws_eip" "fp_nat_eip" {
  count = length(var.nat_subnet_ids)
  tags = merge(var.default_tags, tomap({
    Name = "FP EIP"
  }))
}

resource "aws_nat_gateway" "fp_nat" {
  count = length(aws_eip.fp_nat_eip)
  subnet_id = var.nat_subnet_ids[count.index]
  allocation_id = aws_eip.fp_nat_eip[count.index].id
  tags = merge(var.default_tags, tomap({
    Name = "FP NAT"
  }))
}
