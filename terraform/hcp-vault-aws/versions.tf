terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "hcp-vault-demo-terraform-state"
    key    = "terraform/hcp-vault-aws/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.100"
    }
  }
}

provider "hcp" {
  project_id = var.project_id
}
