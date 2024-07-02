provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "my-tf-config"
    key = "dev/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "training_aws_ec_2_instance" {
  source = "../modules/ec2_instance"
}
