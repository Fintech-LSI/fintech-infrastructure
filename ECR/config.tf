

resource "aws_ecrpublic_repository" "config-service" {
  provider         = aws.us_east_1
  repository_name  = "config-service"

  catalog_data {
    about_text        = "This repository contains Docker images for the config-service project."
    architectures     = ["ARM"]
    description       = "Public repository for config-service project."
  
    operating_systems = ["Linux"]
    usage_text        = "Use these images for config-service-related applications."
  }

  tags = {
    env = "production"
    app = "config-service"
  }
}

output "repository_config" {
  value = aws_ecrpublic_repository.config-service.repository_uri
}
