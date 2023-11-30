variable "bastion_subnet_id" {
  type = string
}
variable "bastion_sg_ids" {
  type = list(string)
}
variable "shared_vpc_name" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "vm_sg_ids" {
  type = list(string)
}
variable "default_tags" {
  type = map(string)
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
