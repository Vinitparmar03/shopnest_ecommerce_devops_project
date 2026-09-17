#############################
# EKS Outputs
#############################

# output "cluster_name" {
#   description = "EKS Cluster Name"
#   value       = aws_eks_cluster.main.name
# }

# output "cluster_arn" {
#   description = "EKS Cluster ARN"
#   value       = aws_eks_cluster.main.arn
# }

# output "cluster_endpoint" {
#   description = "EKS Cluster Endpoint"
#   value       = aws_eks_cluster.main.endpoint
# }

# output "cluster_version" {
#   description = "EKS Kubernetes Version"
#   value       = aws_eks_cluster.main.version
# }

# output "cluster_certificate_authority_data" {
#   description = "Cluster CA Certificate"
#   value       = aws_eks_cluster.main.certificate_authority[0].data
#   sensitive   = true
# }

# output "cluster_security_group_id" {
#   description = "Cluster Security Group ID"
#   value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
# }

# #############################
# # Node Group Outputs
# #############################

# output "node_group_name" {
#   description = "Managed Node Group Name"
#   value       = aws_eks_node_group.default.node_group_name
# }

# output "node_group_arn" {
#   description = "Managed Node Group ARN"
#   value       = aws_eks_node_group.default.arn
# }

# #############################
# # IAM Outputs
# #############################

# output "worker_role_arn" {
#   description = "Worker Node IAM Role ARN"
#   value       = aws_iam_role.worker.arn
# }

# output "jenkins_role_arn" {
#   description = "Jenkins IAM Role ARN"
#   value       = aws_iam_role.jenkins.arn
# }

# #############################
# # Networking Outputs
# #############################

# output "vpc_id" {
#   description = "VPC ID"
#   value       = aws_vpc.main.id
# }

# output "public_subnet_ids" {
#   description = "Public Subnet IDs"
#   value = [
#     aws_subnet.public_subnet_1.id,
#     aws_subnet.public_subnet_2.id
#   ]
# }

# output "private_subnet_ids" {
#   description = "Private Subnet IDs"
#   value = [
#     aws_subnet.private_subnet_1.id,
#     aws_subnet.private_subnet_2.id
#   ]
# }


output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by EKS"
  value       = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
  description = "The cluster security group ID"
  value       = module.eks.cluster_security_group_id
}


