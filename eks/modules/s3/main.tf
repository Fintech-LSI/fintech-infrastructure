# S3 Configuration
# Sets up secure object storage with minimal permissions

# Main S3 bucket with random suffix
resource "aws_s3_bucket" "main" {
  bucket = "microservices-storage-${random_string.suffix.result}"
}

# Generate random suffix for unique bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM policy for EKS nodes to access S3
resource "aws_iam_role_policy" "s3_access" {
  name = "eks-s3-access"
  role = var.node_role_name

  # Allow minimal required S3 operations
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.main.arn,
          "${aws_s3_bucket.main.arn}/*"
        ]
      }
    ]
  })
}