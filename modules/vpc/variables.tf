variable "name" {
  description = "The name of the VPC"
  type = string
}

variable "cidr_block" {
  type = string
}

variable "default_tags" {
  type = map(string)
}

#variable "public_cidrs" {
#  type = list(string)
#}
#
#variable "private_cidrs" {
#  type = list(string)
#}

variable "public_subnets" {
  type = list(object({
    cidr = string
    az = string
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr = string
    az = string
  }))
}


variable "attach_igw" {
  type = bool
  default = true
}

variable "nat_subnet_ids" {
  type = list(string)
}

#variable "nat_subnet_id" {
#  type = string
#}