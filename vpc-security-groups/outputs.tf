output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins.id
}

output "eks_sg_id" {
  value = aws_security_group.eks.id
}
