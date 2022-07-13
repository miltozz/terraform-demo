terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "depl_env_prefix" {}
variable "my_ip" {}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-igw"
  }
}


# Option 1: Create new aws_route_table, and then aws_route_table_association 
# Option 2: Use the aws created default route table, as below (adoption) (advanced resource)

resource "aws_default_route_table" "myapp-default-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.depl_env_prefix}-tf-myapp-default-rtb"
  }
}

/* Option 1: Create security group
resource "aws_security_group" "myapp-sg" {
  name        = "${var.depl_env_prefix}-tf-myapp-sg"
  description = "myapp security group"
  vpc_id      = aws_vpc.myapp-vpc.id
  ...
  ingress
  egress
  ...
*/

# Option 2: Use the aws created, default security group (adoption) (advanced resource)
resource "aws_default_security_group" "myapp-default-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Inbound HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Outbound ALL"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.depl_env_prefix}-myapp-use-default-sg"
  }
}