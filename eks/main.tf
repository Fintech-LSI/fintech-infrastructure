# Main Terraform configuration file
# Configures the AWS provider and orchestrates all modules

provider "aws" {
  region = "us-east-1"
}

# VPC Module - Handles networking infrastructure
module "vpc" {
  source = "./modules/vpc"
}

# IAM Module - Manages roles and permissions
module "iam" {
  source = "./modules/iam"
}

# EKS Module - Creates and configures the Kubernetes cluster
module "eks" {
  source = "./modules/eks"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn = module.iam.node_role_arn
}

# RDS Module - Sets up the database instance
module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  eks_security_group_id = module.eks.cluster_security_group_id
}

# S3 Module - Creates storage bucket and related IAM policies
module "s3" {
  source = "./modules/s3"
  node_role_name = module.iam.node_role_name
}