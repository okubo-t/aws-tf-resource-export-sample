terraform {
  required_providers {
    aws = {
      version = ">= 4.61.0"
      source  = "hashicorp/aws"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }

  #backend "s3" {
  #  bucket         = "tf-resource-export-sample"
  #  key            = "terraform.tfstate"
  #  dynamodb_table = "tf-resource-export-sample"
  #  region         = "ap-northeast-1"
  #}
}

provider "aws" {
  region = "ap-northeast-1"
}
