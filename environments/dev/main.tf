provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "template_file" "cloud_init" {
  template = file("${path.module}/../../configs/linux/cloud-init.yaml")
  vars = {
    hostname           = var.name
    ssh_authorized_key = file("~/.ssh/terrarium-key.pub")
  }
}

module "vm1" {
  source         = "../../modules/core-linux"
  name           = var.name
  ami_id         = "ami-0c3fd0f5d33134a76" # Ubuntu 22.04, Tokyo region
  instance_type  = "t3.micro"
  key_name       = var.key_name
  user_data      = data.template_file.cloud_init.rendered
}
