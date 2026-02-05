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

output "grafana_url" {
  description = "Grafana URL (if observability stack is enabled)"
  value       = var.enable_observability_stack ? module.observability_stack[0].grafana_url : null
}

output "prometheus_url" {
  description = "Prometheus URL (if observability stack is enabled)"
  value       = var.enable_observability_stack ? module.observability_stack[0].prometheus_url : null
}

output "loki_url" {
  description = "Loki URL (if observability stack is enabled)"
  value       = var.enable_observability_stack ? module.observability_stack[0].loki_url : null
}

output "observability_ssh_command" {
  description = "SSH command to connect to observability stack instance"
  value       = var.enable_observability_stack ? "ssh -i ~/.ssh/terrarium-key ubuntu@${module.observability_stack[0].public_ip}" : null
}

output "observability_private_ip" {
  description = "Private IP of observability stack (for Prometheus targets)"
  value       = var.enable_observability_stack ? module.observability_stack[0].private_ip : null
}

output "vm_private_ips" {
  description = "List of VM private IPs for Prometheus scraping"
  value       = [module.vm1.private_ip]
}
