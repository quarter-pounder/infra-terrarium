resource "aws_instance" "vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = var.name
  }

  # Connection/provisioner block later
}
