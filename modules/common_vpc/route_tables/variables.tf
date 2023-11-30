variable "vpc_id" {
  type = string
}
variable "default_tags" {
  type = map(string)
}
variable "nat_id" {
  type    = string
  default = ""
}
variable "igw_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "vpc_cidr" {
  type = string
}
