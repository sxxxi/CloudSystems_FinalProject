terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }
  required_version = ">= 0.14.6"
}

provider "aws" {
  region = "us-east-1"
}

###########################################################################################################
############################   Shared Environment  ########################################################
###########################################################################################################

module "fp_shared_vpc" {
  source = "./modules/vpc"
  name = "VPC-Shared"
  cidr_block = local.shared_vpc_cidr
  attach_igw = true
  private_subnets = local.shared_private_subnets
  public_subnets = local.shared_public_subnets
  nat_subnet_ids = [module.fp_shared_vpc.public_subnets[1].id]
  default_tags = var.default_tags
}

resource "aws_route_table" "fp_shared_public_rt" {
  count = length(module.fp_shared_vpc.igw)
  vpc_id = module.fp_shared_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.fp_shared_vpc.igw[0].id
  }
  tags = merge(var.default_tags, tomap({
    Name = "Shared Public RT"
  }))
}

resource "aws_route_table_association" "fp_shared_public_rt_association" {
  count = length(aws_route_table.fp_shared_public_rt) > 0 ? length(module.fp_shared_vpc.public_subnets) : 0
  route_table_id = aws_route_table.fp_shared_public_rt[0].id
  subnet_id = module.fp_shared_vpc.public_subnets[count.index].id
}

resource "aws_route_table" "fp_shared_private_rt" {
  count = length(module.fp_shared_vpc.nats)
  vpc_id = module.fp_shared_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.fp_shared_vpc.nats[count.index].id
  }
  tags = merge(var.default_tags, tomap({
    Name = "Shared Private RT"
  }))
}

resource "aws_route_table_association" "fp_shared_private_rt_association" {
  count = length(aws_route_table.fp_shared_private_rt) > 0 ? length(module.fp_shared_vpc.private_subnets) : 0
  route_table_id = aws_route_table.fp_shared_private_rt[0].id    # I'll only use the first NAT ID anyway :|
  subnet_id = module.fp_shared_vpc.private_subnets[count.index].id
}


###########################################################################################################
############################   Dev Environment  ###########################################################
###########################################################################################################

module "fp_dev_vpc" {
  source = "./modules/vpc"
  name = "VPC-Dev"
  cidr_block = local.dev_vpc_cidr
  attach_igw = true
  private_subnets = local.dev_private_subnets
  public_subnets = local.dev_public_subnets
  nat_subnet_ids = [module.fp_dev_vpc.public_subnets[1].id]
  default_tags = var.default_tags
}

resource "aws_route_table" "fp_dev_public_rt" {
  count = length(module.fp_dev_vpc.igw)
  vpc_id = module.fp_dev_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.fp_dev_vpc.igw[0].id
  }
  tags = merge(var.default_tags, tomap({
    Name = "Dev Public RT"
  }))
}

resource "aws_route_table_association" "fp_dev_public_rt_association" {
  count = length(aws_route_table.fp_dev_public_rt) > 0 ? length(module.fp_dev_vpc.public_subnets) : 0
  route_table_id = aws_route_table.fp_dev_public_rt[0].id
  subnet_id = module.fp_dev_vpc.public_subnets[count.index].id
}

resource "aws_route_table" "fp_dev_private_rt" {
  count = length(module.fp_dev_vpc.nats)
  vpc_id = module.fp_dev_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.fp_dev_vpc.nats[count.index].id
  }
  tags = merge(var.default_tags, tomap({
    Name = "Dev Private RT"
  }))
}



# SECURITY GROUP DEFINITIONS












