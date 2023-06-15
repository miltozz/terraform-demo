terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}


//var blocks definitions. can also be done on variables.tf
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "depl_env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "public_key_location" {}
variable "private_key_location" {}

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
    from_port       = 0    //any
    to_port         = 0    //any
    protocol        = "-1" //all
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.depl_env_prefix}-myapp-use-default-sg"
  }
}

data "aws_ami" "amazon-linux-latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

//ssh key myst be present and created beforehand
resource "aws_key_pair" "myapp-ssh-key" {
  key_name   = "myapp-server-key"
  public_key = file(var.public_key_location) //doesn't use interpolation syntax ${} as there is no string
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.amazon-linux-latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.myapp-default-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.myapp-ssh-key.key_name
  user_data_replace_on_change = true //forces instance recreation


  /*
  Note 1: user_data: 
  - user_data must be available by the cloud provider.
  - Terraform does not wait for execution or gives feeedback about success or failure on these scripts. It just passes data on the cloud provider. 
  - Debug or reports are not available. Got to SSH to check if everything went OK

  Note 2:
  - user_data touches on configuration management by running shell scripts.
  Terraform is better suited for infra provisioning. Ansible, Puppet, Chef, Salt are 
  better choices for configuring stuff.
*/
  user_data = file("entry-script.sh") //if no file is used, <<EOF syntax needed


  /*
  - Provisioners are a workaround - USE AS LAST RESORT. Not recommended. 
  - Provisioners are against Terraforms principles.Better use configuration tools
  - user_data is better for shell scripts if available
  - Alternative: use the CI tool for executing scripts seperately from Terraform.
  
  There are 3 provisioners in terraform
  */


  //provisioners require connection
  connection {
    type        = "ssh"
    host        = self.public_ip //this
    user        = "ec2-user"
    private_key = file(var.private_key_location)
  }

  provisioner "remote-exec" { //inline
    inline = [
      "mkdir testdir",
      "export ENV=dev"
    ]
  }

  //copy file to remote instance
  provisioner "file" {
    source      = "entry-script.sh"
    destination = "/home/ec2-user/entry-script-on-ec2.sh"
  }

  provisioner "remote-exec" { //use script file
    script = "entry-script-for-remote-exec.sh"
  }

  provisioner "local-exec" { //better to use local_file provider
    command = "echo ${self.public_ip} > instance-public-ip.txt"
  }

#   //another example
#   //connect to some other host and copy using 'file'
#
#   provisioner "file" {
#     source      = "entry-script.sh"
#     destination = "/home/ec2-user/entry-script-on-ec2.sh"

#     connection {
#       type        = "ssh"
#       host        = var.somehost_public_ip //needs to be declared and initialised
#       user        = "ec2-user"
#       private_key = file(var.private_key_location)
#     }

#   }


  tags = {
    Name = "${var.depl_env_prefix}-My App Server"
  }
}

output "data-AMI-id-found" {
  value = data.aws_ami.amazon-linux-latest.id
}

output "instance-myapp-server-public-IP" {
  value = aws_instance.myapp-server.public_ip
}


