project_name = "shopnest"

environment = "dev"

aws_region = "ap-south-1"

vpc_cidr = "10.0.0.0/16"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

eks_version = "1.34"

node_instance_type = "t3.medium"

desired_size = 2

min_size = 2

max_size = 2

jenkins_instance_type = "t3.small"





