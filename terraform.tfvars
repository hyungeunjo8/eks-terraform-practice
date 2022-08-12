# region
aws_region = "ap-northeast-2"
account_id          = "692609349536"

## 아래는 초기 설정 시 변경이 필요한 것
# name prefix
prefix = "prefix"
eks_cluster_name    = "eks"
# codebuild
github_repo         = "https://github.com/hyungeunjo8/eks-fargate-practice"
image_tag           = "latest"
source_version      = "develop"
vpc_cidr = "10.196.0.0/16"
public_subnets = ["10.196.0.0/24", "10.196.1.0/24"]
private_subnets = ["10.196.100.0/24", "10.196.101.0/24"]