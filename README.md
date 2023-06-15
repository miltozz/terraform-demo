# A Terraform demo

## Branch: provisioners
- Testing terraform provisioners.
- Lots of comments in _main.tf_

## Info 
- Instead of creating an SG and an RTB, we use the default ones from the VPC.
- No `variables.tf` file with default values. Needs variable values from a `terraform.tfvars` file (which is usually _.gitignored_) or provide values manually in cli promt.
- Creates one ec2 t2.micro instance and runs user-date and provisioners.
```
  connection

  #The file provisioner copies files or directories from the machine running Terraform to the newly created resource.
  provisioner "file" 

  #The remote-exec provisioner invokes a script on a remote resource after it is created.
  provisioner "remote-exec"

  #The local-exec provisioner invokes a local executable after a resource is created.
  provisioner "local-exec"
```    

- Two outputs show the `ami-id` and the `public ip` of the provisioned EC2 vm 

- Creates the following AWS resources
```
$ terraform plan | grep '#'

  # aws_default_route_table.myapp-default-rtb will be created
  # aws_default_security_group.myapp-default-sg will be created
  # aws_instance.myapp-server will be created
  # aws_internet_gateway.myapp-igw will be created
  # aws_key_pair.myapp-ssh-key will be created
  # aws_subnet.myapp-subnet-1 will be created
  # aws_vpc.myapp-vpc will be created
```