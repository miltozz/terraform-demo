# A Terraform demo

Launch an AWS EKS cluster with EKS Managed Node Groups

[DOC](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)

```
$ terraform plan | grep "will be"
  # module.eks.data.tls_certificate.this[0] will be read during apply
  # module.eks.aws_cloudwatch_log_group.this[0] will be created
  # module.eks.aws_ec2_tag.cluster_primary_security_group["Application"] will be created
  # module.eks.aws_ec2_tag.cluster_primary_security_group["Environment"] will be created
  # module.eks.aws_eks_cluster.this[0] will be created
  # module.eks.aws_iam_openid_connect_provider.oidc_provider[0] will be created
  # module.eks.aws_iam_policy.cluster_encryption[0] will be created
  # module.eks.aws_iam_role.this[0] will be created
  # module.eks.aws_iam_role_policy_attachment.cluster_encryption[0] will be created
  # module.eks.aws_iam_role_policy_attachment.this["AmazonEKSClusterPolicy"] will be created
  # module.eks.aws_iam_role_policy_attachment.this["AmazonEKSVPCResourceController"] will be created
  # module.eks.aws_security_group.cluster[0] will be created
  # module.eks.aws_security_group.node[0] will be created
  # module.eks.aws_security_group_rule.cluster["ingress_nodes_443"] will be created
  # module.eks.aws_security_group_rule.node["egress_all"] will be created
  # module.eks.aws_security_group_rule.node["ingress_cluster_443"] will be created
  # module.eks.aws_security_group_rule.node["ingress_cluster_4443_webhook"] will be created
  # module.eks.aws_security_group_rule.node["ingress_cluster_6443_webhook"] will be created
  # module.eks.aws_security_group_rule.node["ingress_cluster_8443_webhook"] will be created
  # module.eks.aws_security_group_rule.node["ingress_cluster_9443_webhook"] will be created
  # module.eks.aws_security_group_rule.node["ingress_cluster_kubelet"] will be created
  # module.eks.aws_security_group_rule.node["ingress_nodes_ephemeral"] will be created
  # module.eks.aws_security_group_rule.node["ingress_self_coredns_tcp"] will be created
  # module.eks.aws_security_group_rule.node["ingress_self_coredns_udp"] will be created
  # module.eks.time_sleep.this[0] will be created
  # module.myapp-vpc.aws_default_network_acl.this[0] will be created
  # module.myapp-vpc.aws_default_route_table.default[0] will be created
  # module.myapp-vpc.aws_default_security_group.this[0] will be created
  # module.myapp-vpc.aws_eip.nat[0] will be created
  # module.myapp-vpc.aws_internet_gateway.this[0] will be created
  # module.myapp-vpc.aws_nat_gateway.this[0] will be created
  # module.myapp-vpc.aws_route.private_nat_gateway[0] will be created
  # module.myapp-vpc.aws_route.public_internet_gateway[0] will be created
  # module.myapp-vpc.aws_route_table.private[0] will be created
  # module.myapp-vpc.aws_route_table.public[0] will be created
  # module.myapp-vpc.aws_route_table_association.private[0] will be created
  # module.myapp-vpc.aws_route_table_association.private[1] will be created
  # module.myapp-vpc.aws_route_table_association.private[2] will be created
  # module.myapp-vpc.aws_route_table_association.public[0] will be created
  # module.myapp-vpc.aws_route_table_association.public[1] will be created
  # module.myapp-vpc.aws_route_table_association.public[2] will be created
  # module.myapp-vpc.aws_subnet.private[0] will be created
  # module.myapp-vpc.aws_subnet.private[1] will be created
  # module.myapp-vpc.aws_subnet.private[2] will be created
  # module.myapp-vpc.aws_subnet.public[0] will be created
  # module.myapp-vpc.aws_subnet.public[1] will be created
  # module.myapp-vpc.aws_subnet.public[2] will be created
  # module.myapp-vpc.aws_vpc.this[0] will be created
  # module.eks.module.eks_managed_node_group["dev"].aws_eks_node_group.this[0] will be created
  # module.eks.module.eks_managed_node_group["dev"].aws_iam_role.this[0] will be created
  # module.eks.module.eks_managed_node_group["dev"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"] will be created
  # module.eks.module.eks_managed_node_group["dev"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"] will be created
  # module.eks.module.eks_managed_node_group["dev"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"] will be created
  # module.eks.module.eks_managed_node_group["dev"].aws_launch_template.this[0] will be created
  # module.eks.module.kms.data.aws_iam_policy_document.this[0] will be read during apply
  # module.eks.module.kms.aws_kms_alias.this["cluster"] will be created
  # module.eks.module.kms.aws_kms_key.this[0] will be created
  ```