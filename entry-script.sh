#!/bin/bash
echo "Start entry-script.sh"
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
docker run -p 8080:80 nginx
echo "End entry-script.sh"
