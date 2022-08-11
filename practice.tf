# vpc + eks + mks
# terraform init & terraform apply

module "vpc_pracitce" {
  source = "./_modules/vpc"

  aws_region = var.aws_region

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  az              = var.az
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  # https://aws.amazon.com/ko/premiumsupport/knowledge-center/eks-load-balancer-controller-subnets/
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

module "eks_practice" {
  source = "./_modules/eks"

  eks_cluster_name    = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version

  vpc_id          = module.vpc_pracitce.vpc_vpc_id
  private_subnets = module.vpc_pracitce.vpc_private_subnets
}

# module "msk_practice" {
#   source = "./_modules/msk"

#   msk_cluster_name = var.msk_cluster_name
#   kafka_version    = var.kafka_version

#   vpc_private_subnets = module.vpc_pracitce.vpc_private_subnets
#   vpc_vpc_id          = module.vpc_pracitce.vpc_vpc_id
#   vpc_cidr_block      = module.vpc_pracitce.vpc_cidr_block
# }

module "s3_practice" {
  source = "./_modules/s3"

  aws_region  = var.aws_region
  bucket_name = var.bucket_name

  vpc_id                      = module.vpc_pracitce.vpc_vpc_id
  vpc_private_route_table_ids = module.vpc_pracitce.vpc_private_route_table_ids
}

module "dynamodb_practice" {
  source = "./_modules/dynamodb"

  aws_region    = var.aws_region
  dynamodb_name = var.dynamodb_name

  vpc_id                      = module.vpc_pracitce.vpc_vpc_id
  vpc_private_route_table_ids = module.vpc_pracitce.vpc_private_route_table_ids
}

module "codebuild_practice_produce" {
  source              = "./_modules/codebuild_ecr"
  aws_region          = var.aws_region
  account_id          = var.account_id
  codebuild_name      = var.codebuild_name
  github_repo         = var.github_repo
  image_tag           = var.image_tag
  source_version      = var.source_version
  ecr_repository_name = var.ecr_repository_name
}
