# A Terraform demo

## Branch: feature/modules
- Testing terraform modules with simple module creation. 
- Create `subnet` and `webserver` modules for testing purposes.
- Lots of comments in _main.tf_


## Info 

- Similar to `deploy-ec2-no-defaults` branch but we break the resources into modules. 
- Default values in `variables.tf`.
- The `terraform.tfvars` file (which is _.gitignored_) takes precedence over `variables.tf`
- Creates 1, ec2 t2.micro instance and and runs `user_data` from file `entry-script.sh` on boot to:
    - yum update
    - install docker
    - run an nginx container listening all on 8080
- 3 outputs on root module. They are declared in root `outputs.tf` where they call their respective module outputs
    - 2 from `webserver` module which show the `ami-id` and the `public ip` of the provisioned EC2 vm 
    - 1 from `subnet` module which shows the newyly created subnet
- 

- Creates the following AWS resources
```
$ terraform plan | grep '#'

  # aws_vpc.myapp-vpc will be created
  # module.myapp-subnet.aws_internet_gateway.myapp-igw will be created
  # module.myapp-subnet.aws_route_table.myapp-route-table will be created
  # module.myapp-subnet.aws_route_table_association.a-rtb-subnet will be created
  # module.myapp-subnet.aws_subnet.myapp-subnet-1 will be created
  # module.myapp-webserver.aws_instance.myapp-server will be created
  # module.myapp-webserver.aws_key_pair.myapp-ssh-key will be created
  # module.myapp-webserver.aws_security_group.myapp-sg will be created
```

