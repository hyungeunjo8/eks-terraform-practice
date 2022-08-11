# region
aws_region = "ap-northeast-2"

# vpc
vpc_name = "vpc-eks-terraform-practice"
vpc_cidr = "10.196.0.0/16"

#subnet
az              = ["ap-northeast-2a", "ap-northeast-2c"]
public_subnets  = ["10.196.0.0/24", "10.196.1.0/24"]
private_subnets = ["10.196.100.0/24", "10.196.101.0/24"]

# eks
eks_cluster_name    = "eks-terraform-practice"
eks_cluster_version = "1.21"

# msk
msk_cluster_name = "msk-eks-terraform-practice"
kafka_version    = "2.6.2"

# s3
bucket_name = "s3-eks-terraform-practice"

# dynamo
dynamodb_name = "dynamo-eks-terraform-practice"

# codebuild
account_id          = "692609349536"
codebuild_name      = "codebuild-eks-terraform-practice"
github_repo         = "https://github.com/hyungeunjo8/eks-fargate-practice"
image_tag           = "latest"
source_version      = "develop"
ecr_repository_name = "ecr-eks-terraform-practice"