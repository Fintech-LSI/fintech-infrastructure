

resource "aws_ecrpublic_repository" "gateway-service" {
  provider         = aws.us_east_1
  repository_name  = "gateway-service"

  catalog_data {
    about_text        = "This repository contains Docker images for the gateway-service project."
    architectures     = ["ARM"]
    description       = "Public repository for gateway-service project."
  
    operating_systems = ["Linux"]
    usage_text        = "Use these images for gateway-service-related applications."
  }

  tags = {
    env = "production"
    app = "gateway-service"
  }
}

output "repository_gateway" {
  value = aws_ecrpublic_repository.gateway-service.repository_uri
}
