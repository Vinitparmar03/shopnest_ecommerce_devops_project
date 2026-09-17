variable "project_name" {
  description = "Project name"
  type        = string
  default     = "shopnest"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "shopnest-terraform-state"
}
