# Create instances
resource "aws_instance" "fp_shared_bastion" {
  ami                         = local.instance_ami
  instance_type = var.instance_type
  subnet_id                   = var.bastion_subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  security_groups = var.bastion_sg_ids
  tags = merge(var.default_tags, tomap({
    Name = "${var.shared_vpc_name}-bastion"
  }))
}

resource "aws_instance" "fp_shared_vms" {
  count         = length(var.private_subnet_ids)
  ami           = local.instance_ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_ids[count.index]
  key_name      = var.key_name
  security_groups = var.vm_sg_ids
  tags = merge(var.default_tags, tomap({
    Name = "${var.shared_vpc_name}-vm-${count.index + 1}"
  }))
}
