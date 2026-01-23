data "aws_vpc" "default" {
  count   = var.vpc_id == null ? 1 : 0
  default = true
}

locals {
  vpc_id = var.vpc_id != null ? var.vpc_id : (length(data.aws_vpc.default) > 0 ? data.aws_vpc.default[0].id : null)
}

data "aws_subnets" "vpc_subnets" {
  count = var.subnet_id == null ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

data "aws_subnet" "default" {
  count  = var.subnet_id == null ? 1 : 0
  vpc_id = local.vpc_id
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

locals {
  subnet_id = var.subnet_id != null ? var.subnet_id : (length(data.aws_subnet.default) > 0 ? data.aws_subnet.default[0].id : try(data.aws_subnets.vpc_subnets[0].ids[0], null))
}

resource "aws_security_group" "vm" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name} instance"
  vpc_id      = local.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_instance" "vm" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data              = var.user_data
  vpc_security_group_ids = [aws_security_group.vm.id]
  subnet_id              = local.subnet_id
  availability_zone      = var.availability_zone

  tags = {
    Name = var.name
  }
}
