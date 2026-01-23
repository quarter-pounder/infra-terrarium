output "instance_id" {
  description = "EC2 instance ID"
  value       = module.vm1.instance_id
}

output "public_ip" {
  description = "Public IP address"
  value       = module.vm1.public_ip
}

output "private_ip" {
  description = "Private IP address"
  value       = module.vm1.private_ip
}

output "hostname" {
  description = "Instance hostname"
  value       = module.vm1.hostname
}

output "ssh_command" {
  description = "SSH command to connect to the instance (replace ~/.ssh/terrarium-key with your actual key path)"
  value       = "ssh -i ~/.ssh/terrarium-key ubuntu@${module.vm1.public_ip}"
}
