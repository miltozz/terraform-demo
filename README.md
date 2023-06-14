# A Terraform demo

## Branch: bc/deploy-to-ec2 
Similar to bc-project with some changes

## Info 

- No `variables.tf` file with default values. Needs variable values from a `terraform.tfvars` file (which is usually _.gitignored_) or provide values manually in cli promt.
- Creates 2, ec2 t2.micro instances and runs `user_data` with Here Document(EOF syntax) on boot to:
    - yum update
    - install docker
    - run an nginx container listening all on 8080

- Creates the following AWS resources
```
$ terraform plan | grep '#'

# aws_instance.myapp-server will be created
# aws_instance.myapp-server-two will be created
# aws_internet_gateway.myapp-igw will be created
# aws_key_pair.ssh-key will be created
# aws_route_table.myapp-route-table will be created
# aws_route_table_association.a-rtb-subnet will be created
# aws_security_group.myapp-sg will be created
# aws_subnet.myapp-subnet-1 will be created
# aws_vpc.myapp-vpc will be created
```