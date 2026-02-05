output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.observability.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.observability.public_ip
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.observability.private_ip
}

output "hostname" {
  description = "Instance hostname"
  value       = var.name
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.observability.id
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "http://${aws_instance.observability.public_ip}:3000"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${aws_instance.observability.public_ip}:9090"
}

output "loki_url" {
  description = "Loki URL"
  value       = "http://${aws_instance.observability.private_ip}:3100"
}
