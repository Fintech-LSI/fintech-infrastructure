# Output Configuration
# Defines useful output values for reference

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
  description = "Endpoint for EKS control plane"
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
  description = "Name of the EKS cluster"
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region us-east-1"
  description = "Command to configure kubectl"
}