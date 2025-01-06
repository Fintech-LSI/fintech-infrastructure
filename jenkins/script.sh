#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update -y && sudo apt upgrade -y

# Install dependencies for Jenkins
echo "Installing dependencies for Jenkins..."
sudo apt-get install -y fontconfig openjdk-17-jre wget gnupg software-properties-common

# Add Jenkins GPG key and repository
echo "Adding Jenkins GPG key and repository..."
sudo wget -qO /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list after adding Jenkins repository
sudo apt-get update -y

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get install -y jenkins

# Start Jenkins and enable it to start on boot
echo "Starting and enabling Jenkins..."
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
echo "Installing kubectl..."
KUBECTL_VERSION="v1.23.6"
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install Docker
echo "Installing Docker..."
sudo apt update
sudo apt install -y docker.io

# Start and enable Docker
echo "Starting and enabling Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Add Jenkins user to the Docker group
echo "Adding Jenkins user to the Docker group..."
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# Update system again to ensure all packages are up to date
echo "Final system update..."
sudo apt update -y && sudo apt upgrade -y

# Install unzip
echo "Installing unzip..."
sudo apt install -y unzip

# Install AWS CLI
echo "Installing AWS CLI..."
curl -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip -q awscliv2.zip
sudo ./aws/install

# Install Maven
echo "Installing Maven..."
sudo apt install -y maven

# Cleanup
echo "Cleaning up temporary files..."
rm -f awscliv2.zip
rm -rf aws

# Final message
echo "Script execution completed successfully!"
