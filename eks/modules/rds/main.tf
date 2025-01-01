# RDS Configuration
# Sets up a cost-optimized MySQL database

resource "aws_db_instance" "main" {
  identifier           = "main-db"
  allocated_storage    = 20            # Minimum storage in GB
  storage_type         = "gp2"         # General Purpose SSD
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"  # Free tier eligible
  db_name             = "myapp"
  username            = "admin"
  password            = "change_me_in_production"  # Change this in production!
  skip_final_snapshot = true           # Skip final snapshot to avoid additional costs
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 7    # Keep backups for 7 days
  multi_az               = false # Disable Multi-AZ for cost savings
}

# Subnet group for RDS
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = var.subnet_ids
}

# Security group for RDS
resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  # Allow MySQL access from EKS cluster
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_security_group_id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}