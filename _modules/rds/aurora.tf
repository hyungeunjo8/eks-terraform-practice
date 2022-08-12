module "aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name           = var.name
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  instances      = var.instances

  vpc_id  = var.vpc_id
  subnets = var.subnets

  allowed_cidr_blocks = [var.allowed_cidr_blocks]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  enabled_cloudwatch_logs_exports = ["postgresql"]
}
