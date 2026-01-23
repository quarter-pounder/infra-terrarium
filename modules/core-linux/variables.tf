variable "name" {
  description = "Name tag for the instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "key_name" {
  description = "Name of SSH key pair"
  type        = string
}

variable "user_data" {
  description = "Cloud-init script content"
  type        = string
  default     = ""
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
