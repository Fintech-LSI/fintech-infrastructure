provider "aws" {
  region = var.region
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["public-subnet-*"]
  }
}

data "aws_security_group" "jenkins" {
  name = "jenkins-sg"
  vpc_id = data.aws_vpc.main.id
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "jenkins" {
    ami           = "ami-0e2c8caa4b6378d8c"  
  instance_type = "t2.small"
  key_name      = "jenkins-key-2"

  vpc_security_group_ids = [data.aws_security_group.jenkins.id]
  subnet_id              = data.aws_subnets.public.ids[0]

  associate_public_ip_address = true

  user_data = file("script.sh")
  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  tags = {
    Name = "jenkins-instance"
  }
}

resource "aws_iam_role" "jenkins_eks_role" {
  name = "jenkins-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.jenkins_eks_role.name
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.jenkins_eks_role.name
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_eks_role.name
}
# Additional policies for EKS management
resource "aws_iam_role_policy_attachment" "jenkins_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.jenkins_eks_role.name
}

resource "aws_iam_role_policy_attachment" "jenkins_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.jenkins_eks_role.name
}

# Policy for Kubernetes API access
resource "aws_iam_role_policy" "jenkins_eks_kubectl" {
  name = "jenkins-eks-kubectl"
  role = aws_iam_role.jenkins_eks_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListUpdates",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      }
    ]
  })
}


