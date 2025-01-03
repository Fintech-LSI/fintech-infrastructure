output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.main.id
}