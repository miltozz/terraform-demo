resource "aws_default_security_group" "myapp-default-sg" {
  vpc_id = var.vpc_id

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
    name = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_key_pair" "myapp-ssh-key" {
  key_name   = "myapp-server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.amazon-linux-latest.id
  instance_type = var.instance_type
  //subnet_id                   = module.myapp-subnet.my-subnet-1.id //module.<defined-name>.<output-name>
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_default_security_group.myapp-default-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.myapp-ssh-key.key_name
  user_data_replace_on_change = true //forces instance recreation

  user_data = file("./modules/webserver/entry-script.sh")

  tags = {
    Name = "${var.depl_env_prefix}-My App Server"
  }
}