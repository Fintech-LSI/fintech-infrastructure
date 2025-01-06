

resource "aws_ecrpublic_repository" "notification-service" {
  provider         = aws.us_east_1
  repository_name  = "notification-service"

  catalog_data {
    about_text        = "This repository contains Docker images for the notification-service project."
    architectures     = ["ARM"]
    description       = "Public repository for notification-service project."
  
    operating_systems = ["Linux"]
    usage_text        = "Use these images for notification-service-related applications."
  }

  tags = {
    env = "production"
    app = "notification-service"
  }
}

output "repository_notification" {
  value = aws_ecrpublic_repository.notification-service.repository_uri
}
