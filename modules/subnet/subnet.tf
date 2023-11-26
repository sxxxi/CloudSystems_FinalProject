# Subnet
resource "aws_subnet" "fp_subnet" {
  vpc_id            = var.vpc_id
  count             = length(var.subnets)
  cidr_block        = var.subnets[count.index].cidr
  availability_zone = var.subnets[count.index].az
  tags = merge(var.default_tags, tomap({
    Name = "${var.visibility}-subnet-${count.index + 1}"
  }))
}