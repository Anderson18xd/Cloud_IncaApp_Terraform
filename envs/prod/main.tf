data "aws_caller_identity" "current" {}

locals {
  project_name = "webapp"
  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "network" {
  source          = "../../modules/network"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  entorno         = var.environment
  tags_comunes    = local.common_tags
}

module "storage" {
  source      = "../../modules/storage"
  bucket_name = "${local.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}"
  common_tags = local.common_tags
}

module "iam" {
  source        = "../../modules/IAM"
  role_name     = "${local.project_name}-${var.environment}-ec2-role"
  s3_bucket_arn = module.storage.bucket_arn
  common_tags   = local.common_tags
}

module "compute" {
  source                = "../../modules/compute"
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  subnet_id             = module.network.public_subnet_ids["pub-a"]
  instance_profile_name = module.iam.instance_profile_name
  ingress_ports         = var.ingress_ports
  instance_types        = var.instance_types
  tags_comunes          = local.common_tags
}

module "database" {
  source             = "../../modules/database"
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  allowed_sg_id      = module.compute.ec2_sg_id
  db_name            = "${local.project_name}${var.environment}"
  db_username        = "adminuser"
  tags_comunes       = local.common_tags
}
