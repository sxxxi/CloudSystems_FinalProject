output "vpc_id" {
  value = module.vpc.vpc_id
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "public_subnets" {
  value = module.vpc.public_subnets
}

output "vm1_rt" {
  value = module.route_tables.vm1_rt
}
output "vm2_rt" {
  value = module.route_tables.vm2_rt
}
output "bastion_sg_ids" {
  value = [
    module.security_groups.bastion_ssh_sg_id
  ]
}
output "vm_sg_ids" {
  value = [
    module.security_groups.vm_ssh_sg_id,
    module.security_groups.vm_http_sg_id
  ]
}