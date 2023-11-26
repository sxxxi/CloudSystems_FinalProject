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
  source          = "./modules/vpc"
  name            = local.shared_vpc_name
  cidr_block      = local.shared_vpc_cidr
  attach_igw      = true
  private_subnets = local.shared_private_subnets
  public_subnets  = local.shared_public_subnets
  nat_subnet_ids  = [module.fp_shared_vpc.public_subnets[1].id]
  default_tags    = var.default_tags
}

resource "aws_route_table" "fp_shared_public_rt" {
  count  = length(module.fp_shared_vpc.igw)
  vpc_id = module.fp_shared_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.fp_shared_vpc.igw[0].id
  }
  tags = merge(var.default_tags, tomap({
    Name = "shared-public-rt"
  }))
}

resource "aws_route_table_association" "fp_shared_public_rt_association" {
  count          = length(aws_route_table.fp_shared_public_rt) > 0 ? length(module.fp_shared_vpc.public_subnets) : 0
  route_table_id = aws_route_table.fp_shared_public_rt[0].id
  subnet_id      = module.fp_shared_vpc.public_subnets[count.index].id
}

resource "aws_route_table" "fp_shared_private_rt" {
  count  = length(module.fp_shared_vpc.nats)
  vpc_id = module.fp_shared_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = module.fp_shared_vpc.nats[count.index].id
  }
  tags = merge(var.default_tags, tomap({
    Name = "shared-private-rt"
  }))
}

#resource "aws_route" "dev_nat_route" {
#  count = length(module.fp_shared_vpc.nats) > 0 ? length(local.dev_private_subnets) : 0
#  route_table_id = aws_route_table.fp_dev_private_rt.id
#  destination_cidr_block = local.dev_private_subnets[count.index].cidr
#  nat_gateway_id = module.fp_shared_vpc.nats[0].id
#}

resource "aws_route_table_association" "fp_shared_private_rt_association" {
  count          = length(aws_route_table.fp_shared_private_rt) > 0 ? length(module.fp_shared_vpc.private_subnets) : 0
  route_table_id = aws_route_table.fp_shared_private_rt[0].id # I'll only use the first NAT ID anyway :|
  subnet_id      = module.fp_shared_vpc.private_subnets[count.index].id
}

module "fp_shared_bastion_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.fp_shared_vpc.vpc_id
  name   = "${local.shared_vpc_name}-bastion-ssh-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

module "fp_shared_vm_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.fp_shared_vpc.vpc_id
  name   = "${local.shared_vpc_name}-vm-ssh-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = local.shared_vpc_cidr
    }
  ]
  egress_rules = ["all-all"]
}

module "fp_shared_vm_http_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.fp_shared_vpc.vpc_id
  name   = "${local.shared_vpc_name}-vm-http-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = local.shared_vpc_cidr
    }
  ]
  egress_rules = ["all-all"]
}

# Create instances
resource "aws_instance" "fp_shared_bastion" {
  ami           = local.instance_ami
  instance_type = "t2.micro"
  subnet_id     = module.fp_shared_vpc.public_subnets[0].id
  associate_public_ip_address = true
  key_name = "vockey"
  security_groups = [
    module.fp_shared_bastion_ssh_sg.security_group_id
  ]
  tags          = merge(var.default_tags, tomap({
    Name = "${local.shared_vpc_name}-bastion"
  }))
}

resource "aws_instance" "fp_shared_vms" {
  count = length(module.fp_shared_vpc.private_subnets)
  ami = local.instance_ami
  instance_type = "t2.micro"
  subnet_id = module.fp_shared_vpc.private_subnets[count.index].id
  key_name = "vockey"
  security_groups = [
    module.fp_shared_vm_ssh_sg.security_group_id,
    module.fp_shared_vm_http_sg.security_group_id
  ]
  tags = merge(var.default_tags, tomap({
    Name = "${local.shared_vpc_name}-vm-${count.index + 1}"
  }))
}
###########################################################################################################
############################   Dev Environment  ###########################################################
###########################################################################################################

module "fp_dev_vpc" {
  source          = "./modules/vpc"
  name            = local.dev_vpc_name
  cidr_block      = local.dev_vpc_cidr
  attach_igw      = true
  private_subnets = local.dev_private_subnets
  public_subnets  = local.dev_public_subnets
  nat_subnet_ids  = [module.fp_dev_vpc.public_subnets[1].id]
  default_tags    = var.default_tags
}

resource "aws_route_table" "fp_dev_public_rt" {
  count  = length(module.fp_dev_vpc.igw)
  vpc_id = module.fp_dev_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.fp_dev_vpc.igw[0].id
  }
  tags = merge(var.default_tags, tomap({
    Name = "dev-public-rt"
  }))
}

resource "aws_route_table_association" "fp_dev_public_rt_association" {
  count          = length(aws_route_table.fp_dev_public_rt) > 0 ? length(module.fp_dev_vpc.public_subnets) : 0
  route_table_id = aws_route_table.fp_dev_public_rt[0].id
  subnet_id      = module.fp_dev_vpc.public_subnets[count.index].id
}

resource "aws_route_table" "fp_dev_private_rt" {
  count  = length(module.fp_dev_vpc.nats)
  vpc_id = module.fp_dev_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.fp_dev_vpc.nats[count.index].id
  }
  tags = merge(var.default_tags, tomap({
    Name = "dev-private-rt"
  }))
}

resource "aws_route_table_association" "fp_dev_private_rt_association" {
  count          = length(aws_route_table.fp_dev_private_rt) > 0 ? length(module.fp_dev_vpc.private_subnets) : 0
  route_table_id = aws_route_table.fp_dev_private_rt[0].id # I'll only use the first NAT ID anyway :|
  subnet_id      = module.fp_dev_vpc.private_subnets[count.index].id
}

module "fp_dev_bastion_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.fp_dev_vpc.vpc_id
  name   = "${local.dev_vpc_name}-bastion-ssh-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

module "fp_dev_vm_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.fp_dev_vpc.vpc_id
  name   = "${local.dev_vpc_name}-vm-ssh-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = local.dev_vpc_cidr
    }
  ]
  egress_rules = ["all-all"]
}

module "fp_dev_vm_http_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.fp_dev_vpc.vpc_id
  name   = "${local.dev_vpc_name}-vm-http-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = local.dev_vpc_cidr
    }
  ]
  egress_rules = ["all-all"]
}

module "fp_dev_vm_icmp_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.fp_dev_vpc.vpc_id
  name   = "${local.dev_vpc_name}-vm-icmp-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]

}

# Create instances
resource "aws_instance" "fp_dev_bastion" {
  ami           = local.instance_ami
  instance_type = "t2.micro"
  subnet_id     = module.fp_dev_vpc.public_subnets[0].id
  associate_public_ip_address = true
  key_name = "vockey"
  security_groups = [
    module.fp_dev_bastion_ssh_sg.security_group_id
  ]
  tags          = merge(var.default_tags, tomap({
    Name = "${local.dev_vpc_name}-bastion"
  }))
}

resource "aws_instance" "fp_dev_vms" {
  count = length(module.fp_dev_vpc.private_subnets)
  ami = local.instance_ami
  instance_type = "t2.micro"
  subnet_id = module.fp_dev_vpc.private_subnets[count.index].id
  key_name = "vockey"
  security_groups = [
    module.fp_dev_vm_ssh_sg.security_group_id,
    module.fp_dev_vm_http_sg.security_group_id,
    module.fp_dev_vm_icmp_sg.security_group_id
  ]
  tags = merge(var.default_tags, tomap({
    Name = "${local.dev_vpc_name}-vm-${count.index + 1}"
  }))
}

##########################################################################################
###############################  Set up peering  #########################################
##########################################################################################
resource "aws_vpc_peering_connection" "fp_peering" {
  peer_vpc_id = module.fp_dev_vpc.vpc_id
  vpc_id      = module.fp_shared_vpc.vpc_id
  auto_accept = true
}

resource "aws_vpc_peering_connection_accepter" "fp_peering_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.fp_peering.id
  auto_accept = true
}









