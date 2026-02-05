variable "aws_region" {
  default = "ap-northeast-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "key_name" {
  description = "EC2 key pair name"
  default     = "infra_terrarium_core_linux_key"
}

variable "name" {
  description = "Base hostname and Name tag for the VM"
  type        = string
  default     = "dev-linux-01"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/terrarium-key.pub"
}

variable "vpc_id" {
  description = "VPC ID (optional, uses default VPC if null)"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID (optional, uses default subnet if null)"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability zone (optional, uses default if null)"
  type        = string
  default     = null
}

variable "enable_observability_stack" {
  description = "Enable observability stack (Prometheus, Loki, Grafana)"
  type        = bool
  default     = true
}

variable "observability_instance_type" {
  description = "Instance type for observability stack"
  type        = string
  default     = "t3.small"
}
