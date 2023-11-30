output "bastion_ssh_sg_id" {
  value = module.bastion_ssh_sg.security_group_id
}

output "vm_ssh_sg_id" {
  value = module.vm_ssh_sg.security_group_id
}

output "vm_http_sg_id" {
  value = module.vm_http_sg.security_group_id
}