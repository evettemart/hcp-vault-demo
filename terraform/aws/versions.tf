terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "hcp-vault-demo-terraform-state"
    key    = "terraform/aws/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region_1
}

provider "aws" {
  alias  = "region2"
  region = var.aws_region_2
}

provider "aws" {
  alias  = "region3"
  region = var.aws_region_3
}
