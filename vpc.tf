provider "aws" {
  region = "eu-west-3"
}

variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}

data "aws_availablitily_zones" "azs" {}


module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name            = "myapp-vpc"
  cidr            = var.vpc_cidr_block
  azs             = data.aws_availablitily_zones.azs.names
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-cluster" = "shared"
    Terraform   = "true"
    Environment = "dev"
  }
}