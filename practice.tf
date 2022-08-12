# vpc + eks + mks
# terraform init & terraform apply

module "vpc_pracitce" {
  source = "./_modules/vpc"

  name     = "${var.prefix}-vpc"
  vpc_cidr = var.vpc_cidr

  az              = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  # https://aws.amazon.com/ko/premiumsupport/knowledge-center/eks-load-balancer-controller-subnets/
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.prefix}-${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                                      = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.prefix}-${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                             = "1"
  }
}

module "eks_practice" {
  source = "./_modules/eks"

  name        = var.eks_cluster_name
  eks_version = "1.22"

  vpc_id          = module.vpc_pracitce.vpc_id
  private_subnets = module.vpc_pracitce.private_subnets
}

module "msk_practice" {
  source = "./_modules/msk"

  name          = "${var.prefix}-msk"
  kafka_version = "2.6.2"

  private_subnets = module.vpc_pracitce.private_subnets
  vpc_id          = module.vpc_pracitce.vpc_id
  vpc_cidr_block  = module.vpc_pracitce.vpc_cidr_block
}

module "s3_practice" {
  source = "./_modules/s3"

  aws_region = var.aws_region
  name       = "${var.prefix}-s3"

  vpc_id                      = module.vpc_pracitce.vpc_id
  vpc_private_route_table_ids = module.vpc_pracitce.vpc_private_route_table_ids
}

module "dynamodb_practice" {
  source = "./_modules/dynamodb"

  aws_region = var.aws_region
  name       = "${var.prefix}-dynamo"

  vpc_id                      = module.vpc_pracitce.vpc_id
  vpc_private_route_table_ids = module.vpc_pracitce.vpc_private_route_table_ids
}

module "codebuild_practice" {
  source              = "./_modules/codebuild_ecr"
  aws_region          = var.aws_region
  account_id          = var.account_id
  codebuild_name      = "${var.prefix}-codebuild"
  github_repo         = var.github_repo
  image_tag           = var.image_tag
  source_version      = var.source_version
  ecr_repository_name = "${var.prefix}-ecr"
}

module "sqs_pracice" {
  source = "./_modules/sqs"
  name   = "${var.prefix}-sqs.fifo"
}

module "cache_redis_pracice" {
  source               = "./_modules/cache"
  cluster_id           = "${var.prefix}-cache-redis"
  engine               = "redis"
  num_cache_nodes      = "1"
  parameter_group_name = "${var.prefix}-default.redis3.2"
  engine_version       = "3.2.10"
  port                 = "6379"
  node_type            = "cache.m4.large"
  subnet_ids           = module.vpc_pracitce.private_subnets
  vpc_id               = module.vpc_pracitce.vpc_id
  vpc_cidr_block       = module.vpc_pracitce.vpc_cidr_block
  subnet_group_name    = "${var.prefix}-cache-redis-subnet-group"
}

module "memorydb_redis_pracice" {
  source                   = "./_modules/memorydb"
  name                     = "${var.prefix}-memorydb-redis"
  node_type                = "db.t4g.small"
  num_shards               = "2"
  snapshot_retention_limit = "7"
  port                     = "6379"
  subnet_group_name        = "${var.prefix}-memorydb-redis-subnet-group"
  subnet_ids               = module.vpc_pracitce.private_subnets
  vpc_id                   = module.vpc_pracitce.vpc_id
  vpc_cidr_block           = module.vpc_pracitce.vpc_cidr_block
}

module "rds_aurora_practice" {
  source         = "./_modules/rds"
  name           = "${var.prefix}-rds-aurora"
  engine         = "aurora-postgresql"
  engine_version = "11.12"
  instance_class = "db.r6g.large"
  instances = {
    one = {}
    2 = {
      instance_class = "db.r6g.2xlarge"
    }
  }
  vpc_id              = module.vpc_pracitce.vpc_id
  subnets             = module.vpc_pracitce.private_subnets
  allowed_cidr_blocks = module.vpc_pracitce.vpc_cidr_block
}

module "secretsmanager_practice" {
  source = "./_modules/secretsmanager"
  name   = "${var.prefix}-secretmanager"

}
