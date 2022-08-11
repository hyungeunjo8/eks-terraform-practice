provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:${var.aws_region}:${var.account_id}:cluster/${var.eks_cluster_id}"
}

module "iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = var.eks_pod_iam_role_for_service_accounts_name

  oidc_providers = {
    main = {
      provider_arn               = "arn:aws:iam::${var.account_id}:oidc-provider/${replace(var.eks_cluster_oidc_issuer_url, "https://", "")}"
      namespace_service_accounts = ["default:${var.eks_pod_service_account_name}"]
    }
  }
  role_policy_arns = var.eks_service_account_policy
}

resource "kubernetes_service_account" "service-accounts" {
  metadata {
    name      = var.eks_pod_service_account_name
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.account_id}:role/${var.eks_pod_iam_role_for_service_accounts_name}"
    }
  }
}
