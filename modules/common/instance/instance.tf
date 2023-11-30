# Creates one instance for each subnet id provided
resource "aws_instance" "fp_instance" {
  count                       = length(var.subnet_ids)
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.subnet_ids[count.index]
  iam_instance_profile = "LabRole"
  tags = merge(var.default_tags, tomap({
    Name = "${var.name_prefix}${var.name_prefix ? "-" : ""}vm-${count.index + 1}"
  }))
}