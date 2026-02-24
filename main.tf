provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = {
    a = { cidr = "10.0.1.0/24", az = "eu-north-1a" }
    b = { cidr = "10.0.2.0/24", az = "eu-north-1b" }
  }

  private_subnets = {
    a = { cidr = "10.0.3.0/24", az = "eu-north-1a" }
    b = { cidr = "10.0.4.0/24", az = "eu-north-1c" }
  }

  enable_nat_gateway = true
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  alb_sg_id         = module.sg.alb_sg_id
  public_subnet_ids = module.vpc.public_subnets
}

module "asg" {
  source           = "./modules/asg"
  ami_id           = var.ami_id
  instance_type     = local.instance_type
  ec2_sg_ids       = [module.sg.ec2_sg_id]
  private_subnet_ids = module.vpc.private_subnets
  target_group_arn = module.alb.app_tg_arn
}

module "rds" {
  source = "./modules/rds"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  ec2_sg_id = module.sg.ec2_sg_id

  db_name       = "appdb"
  db_username   = "admin"
  db_password   = "StrongPassword123!"
  multi_az      = true
}