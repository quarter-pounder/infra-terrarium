variable "aws_region" {
  default = "ap-northeast-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "key_name" {
  description = "EC2 key pair name"
  default     = "infra_terrarium_core_linux_key"
}
