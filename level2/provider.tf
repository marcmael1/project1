terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "remote-state00"
    key            = "level2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-stateD"
  }
}

provider "aws" {
  region = "us-east-1"
}
