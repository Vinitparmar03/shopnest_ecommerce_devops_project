variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "shopnest"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public Subnets"

  type = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnets" {
  description = "Private Subnets"

  type = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "availability_zones" {

  description = "Availability Zones"

  type = list(string)

  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

variable "eks_version" {

  description = "EKS Version"

  type    = string
  default = "1.34"
}

variable "node_instance_type" {

  description = "Worker Node Instance Type"

  type    = string
  default = "t2.micro"
}

variable "desired_size" {

  type    = number
  default = 2
}

variable "min_size" {

  type    = number
  default = 2
}

variable "max_size" {

  type    = number
  default = 2
}

variable "jenkins_instance_type" {
  type    = string
  default = "t3.small"
}




