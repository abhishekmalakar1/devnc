provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "subnets" {
  source = "./modules/subnets"
}

module "security_groups" {
  source = "./modules/security_groups"
}

module "asg" {
  source = "./modules/asg"
}
