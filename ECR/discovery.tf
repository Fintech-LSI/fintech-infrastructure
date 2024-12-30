

resource "aws_ecrpublic_repository" "repository_discovery-service" {
  provider         = aws.us_east_1
  repository_name  = "repository_discovery-service"

  catalog_data {
    about_text        = "This repository contains Docker images for the repository_discovery-service project."
    architectures     = ["ARM"]
    description       = "Public repository for repository_discovery-service project."
  
    operating_systems = ["Linux"]
    usage_text        = "Use these images for repository_discovery-service-related applications."
  }

  tags = {
    env = "production"
    app = "repository_discovery-service"
  }
}

output "repository_repository_discovery" {
  value = aws_ecrpublic_repository.repository_discovery-service.repository_uri
}
