

resource "aws_ecrpublic_repository" "wallet-service" {
  provider         = aws.us_east_1
  repository_name  = "wallet-service"

  catalog_data {
    about_text        = "This repository contains Docker images for the wallet-service project."
    architectures     = ["ARM"]
    description       = "Public repository for wallet-service project."
  
    operating_systems = ["Linux"]
    usage_text        = "Use these images for wallet-service-related applications."
  }

  tags = {
    env = "production"
    app = "wallet-service"
  }
}

output "repository_wallet" {
  value = aws_ecrpublic_repository.wallet-service.repository_uri
}
