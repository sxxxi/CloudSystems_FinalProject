module "vpc" {
  source          = "../common/vpc"
  name            = var.vpc_name
  cidr_block      = var.vpc_cidr
  attach_igw      = true
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  nat_subnet_id   = module.vpc.public_subnets[1].id
  default_tags    = var.default_tags
}

# SharedVPC route table creation and association
module "route_tables" {
  source             = "./route_tables"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  igw_id             = module.vpc.igw.id
  nat_id             = module.vpc.nat.id
  private_subnet_ids = module.vpc.private_subnets[*].id
  public_subnet_ids  = module.vpc.public_subnets[*].id
  default_tags       = var.default_tags
}

# Define security groups
module "security_groups" {
  source = "./security_groups"
  vpc_id = module.vpc.vpc_id
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
}