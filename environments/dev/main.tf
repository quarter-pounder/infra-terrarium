provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  alloy_config = templatefile("${path.module}/../../configs/linux/config.alloy", {
    hostname = var.name
  })

  cloud_init_vars = {
    hostname           = var.name
    ssh_authorized_key = file(pathexpand(var.ssh_public_key_path))
    alloy_config       = local.alloy_config
  }
}

module "vm1" {
  source            = "../../modules/core-linux"
  name              = var.name
  ami_id            = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  key_name          = var.key_name
  user_data         = templatefile("${path.module}/../../configs/linux/cloud-init.yaml", local.cloud_init_vars)
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  availability_zone = var.availability_zone
}
