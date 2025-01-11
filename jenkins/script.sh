#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

echo "Updating and upgrading the system..."
sudo apt update -y && sudo apt upgrade -y

# Install dependencies for Jenkins
echo "Installing dependencies for Jenkins..."
sudo apt-get install -y fontconfig openjdk-17-jre wget gnupg software-properties-common unzip

# Add Jenkins GPG key and repository
echo "Adding Jenkins GPG key and repository..."
sudo wget -qO /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
echo "Installing Jenkins..."
sudo apt-get install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Git
echo "Installing Git..."
sudo apt install -y git

# Install Terraform
echo "Installing Terraform..."
wget -qO- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt update -y
sudo apt install -y terraform

# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.2/2024-11-15/bin/linux/amd64/kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.2/2024-11-15/bin/linux/amd64/kubectl.sha256
sha256sum -c kubectl.sha256
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

# Install Docker using Docker's repository
echo "Installing Docker..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# Install AWS CLI
echo "Installing AWS CLI..."
curl -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -f awscliv2.zip
rm -rf aws

# Install Maven
echo "Installing Maven..."
sudo apt install -y maven

echo "Final system update..."
sudo apt update -y && sudo apt upgrade -y

echo "Script execution completed successfully!"
