

resource "aws_ecrpublic_repository" "user-service" {
  provider         = aws.us_east_1
  repository_name  = "user-service"

  catalog_data {
    about_text        = "This repository contains Docker images for the user-service project."
    architectures     = ["ARM"]
    description       = "Public repository for user-service project."
  
    operating_systems = ["Linux"]
    usage_text        = "Use these images for user-service-related applications."
  }

  tags = {
    env = "production"
    app = "user-service"
  }
}

output "repository_user" {
  value = aws_ecrpublic_repository.user-service.repository_uri
}
