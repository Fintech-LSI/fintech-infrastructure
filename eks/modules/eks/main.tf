# EKS Cluster Configuration
# Sets up a cost-optimized Kubernetes cluster

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "main-eks-cluster"
  role_arn = var.cluster_role_arn
  version  = "1.27"  # Specify Kubernetes version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true   # Allow public access to API server
    endpoint_private_access = false  # Disable private access to save costs
  }
}

# EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "main-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  # Cost-optimized scaling configuration
  scaling_config {
    desired_size = 1  # Start with single node
    max_size     = 2  # Allow scaling up to 2 nodes
    min_size     = 1  # Maintain at least 1 node
  }

  instance_types = ["t3.small"]  # Free tier eligible instance type
}