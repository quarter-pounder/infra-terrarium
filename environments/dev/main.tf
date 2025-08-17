provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "vm1" {
  source         = "../../modules/core-linux"
  name           = "dev-linux-01"
  ami_id         = "ami-0c3fd0f5d33134a76" # Ubuntu 22.04, Tokyo region
  instance_type  = "t3.micro"
  key_name       = var.key_name
}
