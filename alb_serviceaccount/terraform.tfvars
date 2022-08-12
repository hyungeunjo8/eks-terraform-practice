aws_region                                 = "ap-northeast-2"
account_id                                 = "692609349536"
eks_pod_service_account_name               = "eks-terraform-practice-service-account"
eks_pod_iam_role_for_service_accounts_name = "iam-role-eks-terraform-practice"
eks_service_account_policy = {
    AmazonS3FullAccess       = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    AmazonDynamoDBFullAccess = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    AmazonSQSFullAccess = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}