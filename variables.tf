variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "depl_env_prefix" {
  description = "Deployment environment prefix"
  type        = string
  default     = "dev"
}

variable "subnet_cidr_block" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "avail_zone" {
  description = "Subnet AZ"
  type        = string
  default     = "eu-central-1a"
}