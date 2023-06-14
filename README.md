# A Terraform demo

## Branch: bc/deploy-to-ec2-with-defaults
Similar to bc-project with some changes

## Info 

- Instead of creating an SG and an RTB, we use the default ones from the VPC.
- Shows examples of using resource `aws_security_group_rule`. (they are commented-out)
- No `variables.tf` file with default values. Needs variable values from a `terraform.tfvars` file (which is usually _.gitignored_) or provide values manually in cli promt.
- Creates one ec2 t2.micro instance and runs `user_data` from file `entry-script.sh` on boot to:
    - yum update
    - install docker
    - run an nginx container listening all on 8080

- Two outputs show the `ami-id` and the `public ip` of the provisioned EC2 vm 
- Creates the following AWS resources
```
$ terraform plan | grep '#'

# aws_default_route_table.main-rtb will be created
# aws_default_security_group.default-sg will be created
# aws_instance.myapp-server will be created
# aws_internet_gateway.myapp-igw will be created
# aws_key_pair.ssh-key will be created
# aws_subnet.myapp-subnet-1 will be created
# aws_vpc.myapp-vpc will be created
```