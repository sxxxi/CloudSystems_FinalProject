variable "ami" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  default = "t2.micro"
}

variable "name_prefix" {
  type    = string
  default = ""
}

variable "default_tags" {
  type = map(string)
}
