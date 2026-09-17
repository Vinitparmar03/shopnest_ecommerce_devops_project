terraform {
  backend "s3" {
    bucket       = "shopnest-terraform-state"
    key          = "eks/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}