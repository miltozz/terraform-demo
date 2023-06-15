# A Terraform demo

## Branch: deploy-to-ec2-no-defaults 

## Info 

- No `variables.tf` file with default values. Needs variable values from a `terraform.tfvars` file (which is usually _.gitignored_) or provide values manually in cli promt.
- Creates 2, ec2 t2.micro instances and and runs `user_data` from file `entry-script.sh` on boot to:
    - yum update
    - install docker
    - run an nginx container listening all on 8080

- Two outputs show the `ami-id` and the `public ip` of the provisioned EC2 vm 

- Creates the following AWS resources
```
$ terraform plan | grep '#'

  # aws_instance.myapp-server will be created
  # aws_internet_gateway.myapp-igw will be created
  # aws_key_pair.myapp-ssh-key will be created
  # aws_route_table.myapp-rtb will be created
  # aws_route_table_association.a-rtb-subnet will be created
  # aws_security_group.myapp-sg will be created
  # aws_subnet.myapp-subnet-1 will be created
  # aws_vpc.myapp-vpc will be created
```