output "vpc_id" {
  value = aws_vpc.fp_vpc.id
}

output "nats" {
  value = aws_nat_gateway.fp_nat
}

output "igw" {
  value = aws_internet_gateway.fp_igw
}

output "public_subnets" {
  value = module.fp_public_subnets.subnets
}

output "private_subnets" {
  value = module.fp_private_subnets.subnets
}