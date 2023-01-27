# A Terraform demo

Learning Terraform :)


Creates AWS resources:
```
$ terraform state list

data.aws_ami.amazon-linux-latest
aws_instance.myapp-server
aws_internet_gateway.myapp-igw
aws_key_pair.myapp-ssh-key
aws_route_table.myapp-route-table
aws_route_table_association.a-rtb-subnet
aws_security_group.myapp-sg
aws_vpc.myapp-vpc
```

- Not using default resources (sg, rtb)
- Uses ssh key from $HOME/.ssh
- Needs IP to create SG SSH ingress on 22
- Creates EC2 instance, runs `entry-script.sh` with `user-data` which installs docker and runs nginx image on 8080
- Not all vars declared are used