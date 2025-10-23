module "vpc" {
  source          = "../modules/vpc"
  region          = var.region
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pri_sub_3a_cidr = var.pri_sub_3a_cidr
}

module "keypair" {
  source   = "../modules/key"
  key_name = var.key_name
}

module "sg" {
  source  = "../modules/sg"
  sg_name = var.sg_name
  vpc_id  = module.vpc.vpc_id
}

module "ec2" {
  source            = "../modules/ec2"
  ami_id            = var.ami_id
  project_name    = var.project_name
  instance_type     = var.instance_type
  key_name          = module.keypair.key_name
  security_group_id = module.sg.sg_id
  instance_name     = var.instance_name
  subnet_id         = module.vpc.pub_sub_1a_id

}

module "terraform_bucket" {
  source       = "../modules/s3_bucket"
  bucket_name  = "terraform-created-209"
  enable_versioning = true
  tags = {
    Environment = "POC"
    Project     = "Terraform"
  }
}

