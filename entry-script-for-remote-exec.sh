#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo usermod -aG docker ec2-user
sudo systemctl start docker
# docker run fails without sudo
# detach (-d) so remote exec can be signaled to finish.
sudo docker run -dp 8080:80 nginx