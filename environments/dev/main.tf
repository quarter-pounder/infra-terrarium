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

module "observability_stack" {
  count = var.enable_observability_stack ? 1 : 0

  source            = "../../modules/observability"
  name              = "dev-observability"
  ami_id            = data.aws_ami.ubuntu.id
  instance_type     = var.observability_instance_type
  key_name          = var.key_name
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  availability_zone = var.availability_zone

  user_data = templatefile("${path.module}/../../configs/shared/cloud-init-observability.yaml", {
    hostname                    = "dev-observability"
    ssh_authorized_key          = file(pathexpand(var.ssh_public_key_path))
    docker_compose_config       = file("${path.module}/../../configs/shared/docker-compose.yaml")
    prometheus_config           = file("${path.module}/../../configs/shared/prometheus.yaml")
    loki_config                 = file("${path.module}/../../configs/shared/loki-config.yaml")
    grafana_datasources_config  = file("${path.module}/../../configs/shared/grafana-provisioning/datasources/datasources.yaml")
  })
}

locals {
  loki_url = var.enable_observability_stack ? "http://${module.observability_stack[0].private_ip}:3100" : "http://localhost:3100"
  
  alloy_config = templatefile("${path.module}/../../configs/linux/config.alloy", {
    hostname  = var.name
    loki_url  = local.loki_url
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

  depends_on = [module.observability_stack]
}
