locals {

  cluster_name = "${var.project_name}-${var.environment}-eks"
  create_kms   = false
  common_tags = {

    Project = var.project_name

    Environment = var.environment

    Terraform = "true"

    Owner = "Vinit"

    ManagedBy = "Terraform"
  }
}