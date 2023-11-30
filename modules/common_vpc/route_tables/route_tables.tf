# SHARED VPC PUBLIC SUBNET ROUTE TABLE
# Forward all traffic to IGW
resource "aws_route_table" "fp_shared_public_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = merge(var.default_tags, tomap({
    Name = "shared-public-rt"
  }))
}

# SHARED VPC PRIVATE SUBNET ROUTE TABLE
# Forward all traffic to the NAT GW
resource "aws_route_table" "fp_shared_private_rt_1" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_id
  }
  tags = merge(var.default_tags, tomap({
    Name = "shared-private-rt"
  }))
}

resource "aws_route_table" "fp_shared_private_rt_2" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_id
  }
  tags = merge(var.default_tags, tomap({
    Name = "shared-private-rt"
  }))
}



# EXPERIMENT: attach to subnet 2 and ping google from private subnet
# Associate PUBLIC SUBNET ROUTE TABLE to BASTION SUBNET
resource "aws_route_table_association" "fp_shared_public_rt_association" {
  route_table_id = aws_route_table.fp_shared_public_rt.id
  subnet_id      = var.public_subnet_ids[0]
}

# SHARED VPC PRIVATE ROUTE TABLE ASSOCIATION
# Attach to all private subnets
resource "aws_route_table_association" "fp_shared_private_rt_vm1_association" {
  route_table_id = aws_route_table.fp_shared_private_rt_1.id
  subnet_id      = var.private_subnet_ids[0]
}
resource "aws_route_table_association" "fp_shared_private_rt_vm2_association" {
  route_table_id = aws_route_table.fp_shared_private_rt_2.id
  subnet_id      = var.private_subnet_ids[1]
}


