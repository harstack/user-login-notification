//Specify the required terraform providers
provider "aws" {
  region = "us-east-1"
}

//This is where you can specify the additional required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.1.0"
    }
  }
  required_version = "1.4.6"
}