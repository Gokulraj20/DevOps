# configure aws provider
provider "aws" {
  region = var.region
  profile = ""
}


# create vpc
module "vpc" {
  source                         = "../Terraform/module/vpc"
  region                         = var.region
  project-name                   = var.project-name
  vpc-cidr                       = var.vpc-cidr
  public-subnet-az1-cidr         = var.public-subnet-az1-cidr
  public-subnet-az2-cidr         = var.public-subnet-az2-cidr
  private-app-subnet-az1-cidr    = var.private-app-subnet-az1-cidr
  private-app-subnet-az2-cidr    = var.private-app-subnet-az2-cidr
  private-db-subnet-az1-cidr     = var.private-db-subnet-az1-cidr
  private-db-subnet-az2-cidr     = var.private-db-subnet-az2-cidr
}