terraform {
  backend "s3" {
    bucket         = "mytestbucket-mangesh"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}