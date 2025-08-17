resource "aws_instance" "vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data              = var.user_data

  tags = {
    Name = var.name
  }

  # Connection/provisioner block later
}
