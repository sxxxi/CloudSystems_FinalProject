module "bastion_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = var.vpc_id
  name   = "${var.vpc_name}-bastion-ssh-sg"
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

module "vm_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = var.vpc_id
  name   = "${var.vpc_name}-vm-ssh-sg"
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

module "vm_http_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = var.vpc_id
  name   = "${var.vpc_name}-vm-http-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = -1
      to_port = -1
      protocol  = "icmp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

