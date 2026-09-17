module "eks" {
  source = "./modules/eks"

  name = local.cluster_name

  # --------------------------------------------------
  # KMS / Encryption
  # --------------------------------------------------

  create_kms_key    = false
  encryption_config = null

  # --------------------------------------------------
  # EKS Add-ons
  # --------------------------------------------------

  addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
  }

  # --------------------------------------------------
  # EKS API Endpoint
  # --------------------------------------------------

  endpoint_public_access  = true
  endpoint_private_access = true

  # --------------------------------------------------
  # EKS Access
  # --------------------------------------------------

  enable_cluster_creator_admin_permissions = true

  # --------------------------------------------------
  # VPC
  # --------------------------------------------------

  vpc_id = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  # --------------------------------------------------
  # Managed Node Group
  # --------------------------------------------------

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      kubernetes_version = "1.36"

      ami_type = "AL2023_x86_64_STANDARD"

      instance_types = [
        var.node_instance_type
      ]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      disk_size = 20
    }
  }
}