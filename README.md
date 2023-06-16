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

---

```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

data-AMI-id = "ami-0aecab792d09b6d55"
instance-public-IP = "0.0.254.61"
subnet = {
  "arn" = "arn:aws:ec2:eu-central-1:99999999999:subnet/subnet-0a76dff1ee7c6955c"
  "assign_ipv6_address_on_creation" = false
  "availability_zone" = "eu-central-1b"
  "availability_zone_id" = "euc1-az3"
  "cidr_block" = "10.0.1.0/24"
  "customer_owned_ipv4_pool" = ""
  "enable_dns64" = false
  "enable_lni_at_device_index" = 0
  "enable_resource_name_dns_a_record_on_launch" = false
  "enable_resource_name_dns_aaaa_record_on_launch" = false
  "id" = "subnet-0a76dff1ee7c6955c"
  "ipv6_cidr_block" = ""
  "ipv6_cidr_block_association_id" = ""
  "ipv6_native" = false
  "map_customer_owned_ip_on_launch" = false
  "map_public_ip_on_launch" = false
  "outpost_arn" = ""
  "owner_id" = "99999999999"
  "private_dns_hostname_type_on_launch" = "ip-name"
  "tags" = tomap({
    "Name" = "dev-tf-myapp-subnet-1"
  })
  "tags_all" = tomap({
    "Name" = "dev-tf-myapp-subnet-1"
  })
  "timeouts" = null /* object */
  "vpc_id" = "vpc-02f4bcf20d1431026"
}
```