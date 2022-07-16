output "data-AMI-id" {
  value = module.myapp-webserver.data-AMI-id-found
}

output "instance-public-IP" {
  value = module.myapp-webserver.instance-myapp-server-public-IP
}