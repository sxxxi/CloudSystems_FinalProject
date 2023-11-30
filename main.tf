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
#################  Questions and my answers/solutions  ####################################################
###########################################################################################################
### 4.1
# Admin  SSH --->  VPC-Shared-Bastion  SSH --->  VPC-Shared-VM(1|2)
#
# Solution: Create ssh-sg for each instance
# Implementation: `modules/common_vpc/security_groups`

### 4.2
# VPC-Shared-VM1  <--- ICMP --->  VPC-Shared-VM2
#
# Solution: Set ICMP security group rule to only accept traffic from the other private subnet
# Implementation: `modules/common_vpc/security_groups`

### 4.4
# VPC-Shared-VM1  ICMP -x->  VPC-Dev-VM1
# VPC-Shared-VM2  ICMP --->  VPC-Dev-VM1
#
# Solution: only associate route tables to SharedVPC subnet 2 and DevVpc subnet 1

### BONUS 4.5
# VPC-Shared-VM1  ICMP -x->  VPC-Dev-VM2
# VPC-Shared-VM2  ICMP -x->  VPC-Dev-VM2
#
# Solution: Set requester route table destination to Dev subnet 1 CIDR instead of DevVPC CIDR. Do the same to accepter


###########################################################################################################
####################################  Environments  #######################################################
###########################################################################################################

# SharedVPC
module "fp_shared_vpc" {
  source = "./modules/common_vpc"
  vpc_name = local.shared_vpc_name
  vpc_cidr = local.shared_vpc_cidr
  public_subnets = local.shared_public_subnets
  private_subnets = local.shared_private_subnets
  default_tags = var.default_tags
}

# DevVPC
module "fp_dev_vpc" {
  source = "./modules/common_vpc"
  vpc_name = local.dev_vpc_name
  vpc_cidr = local.dev_vpc_cidr
  public_subnets = local.dev_public_subnets
  private_subnets = local.dev_private_subnets
  default_tags = var.default_tags
}

###########################################################################################################
#############################  Peering  ######  4.4  and 4.5  #############################################
###########################################################################################################

# NOTE: I created a route table for each subnet and I exposed the route tables of the private subnets
#       as output variables of `common_vpc.tf`. This way, I have a fine control of which table I should
#       attach new routes I create.

# Connection
resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id      = module.fp_shared_vpc.vpc_id
  peer_vpc_id = module.fp_dev_vpc.vpc_id
  auto_accept = true
}

# Requester route
# Add route to the route table of SharedVPC Private Subnet 2
resource "aws_route" "shared_private_to_dev_private_route" {
  route_table_id = module.fp_shared_vpc.vm2_rt.id   # 4.4: Attach only to SharedVPC SN2
  destination_cidr_block = local.dev_private_subnets[0].cidr    # 4.5
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

# Accepter route
# Add route to the route table of DevVPC Private Subnet 1
resource "aws_route" "dev_private_to_shared_private_route" {
  route_table_id = module.fp_dev_vpc.vm1_rt.id      # 4.4: Attach only to DevVPC SN1
  destination_cidr_block = local.shared_private_subnets[1].cidr     # 4.5
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

###########################################################################################################
###########################################################################################################


# S3
module "fp_s3" {
  source = "./modules/common/bucket"
}

























