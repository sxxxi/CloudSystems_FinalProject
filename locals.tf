locals {
  shared_vpc_name = "SharedVPC"
  shared_vpc_cidr = "10.0.0.0/16"
  shared_public_subnets = [
    {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "10.0.2.0/24"
      az   = "us-east-1b"
    }
  ]
  shared_private_subnets = [
    {
      cidr = "10.0.3.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "10.0.4.0/24"
      az   = "us-east-1b"
    }
  ]

  dev_vpc_name = "DevVPC"
  dev_vpc_cidr = "192.168.0.0/16"
  dev_public_subnets = [
    {
      cidr = "192.168.1.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "192.168.2.0/24"
      az   = "us-east-1b"
    }
  ]
  dev_private_subnets = [
    {
      cidr = "192.168.3.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "192.168.4.0/24"
      az   = "us-east-1b"
    }
  ]




  instance_ami = "ami-0230bd60aa48260c6"
  key_name = "vockey"
  instance_type = "t2.micro"

}