provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "467.devops.candidate.exam"
    key    = "Your.FirstName.YourLastName"
    region = "ap-south-1"
  }
}
