output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.vm.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.vm.public_ip
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.vm.private_ip
}

output "hostname" {
  description = "Instance hostname"
  value       = var.name
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.vm.id
}
