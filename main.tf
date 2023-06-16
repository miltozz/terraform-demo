terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-vpc"
  }
}

module "myapp-subnet" {
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.myapp-vpc.id //no var, it is declared above, in the same file
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  depl_env_prefix   = var.depl_env_prefix
  //default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-webserver" {
  source              = "./modules/webserver"
  vpc_id              = aws_vpc.myapp-vpc.id
  my_ip               = var.my_ip
  depl_env_prefix     = var.depl_env_prefix
  image_name          = var.image_name
  public_key_location = var.public_key_location
  instance_type       = var.instance_type
  avail_zone          = var.avail_zone
  subnet_id           = module.myapp-subnet.my-subnet-1-out.id//reads from the module output which returns the whole created resource
 
}
