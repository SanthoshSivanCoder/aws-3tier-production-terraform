terraform {
  backend "s3" {
    bucket         = "terraform-production-stage-fire"
    key            = "env/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
} 