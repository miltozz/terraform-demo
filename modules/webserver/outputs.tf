output "data-AMI-id-found" {
  value = data.aws_ami.amazon-linux-latest.id
}

output "instance-myapp-server-public-IP" {
  value = aws_instance.myapp-server.public_ip
}