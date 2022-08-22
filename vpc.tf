terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }
  backend "s3" {
    bucket = "bucketfortesting3"
    key    = "my-eks/tf-states/eks-tfstate"
    region = "eu-west-3"
  }
}

provider "aws" {
  region = "eu-central-1"
}

variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}

data "aws_availability_zones" "azs" {}


module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name            = "myapp-vpc"
  cidr            = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  azs             = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared" //labels for Cloud Controller Manager
    Terraform                                 = "true"
    Environment                               = "dev"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared" //labels for K8s CCM
    "kubernetes.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared" //labels for K8s CCM
    "kubernetes.io/role/internal-elb"         = 1
  }
}