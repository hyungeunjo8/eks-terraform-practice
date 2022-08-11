variable "vpc_id" {
}
variable "private_subnets" {
  type = list(string)
}
variable "eks_cluster_version" {}
variable "eks_cluster_name" {}
