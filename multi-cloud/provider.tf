terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.project
  region  = var.gcp_region
}