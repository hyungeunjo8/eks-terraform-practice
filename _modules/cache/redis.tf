resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_id
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.group.id
  engine_version       = var.engine_version
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.subnet_group.id
  security_group_ids   = [aws_elasticache_security_group.elasticache_security_group.id]
}

resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_security_group" "elasticache_security_group" {
  name                 = "elasticache-redis-security-group"
  security_group_names = [aws_security_group.redis_security_group.id]
}


resource "aws_security_group" "redis_security_group" {
  name        = "${var.cluster_id}-security-group"
  description = "${var.cluster_id} Redis Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    description = "bootstrap port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Internal outbound traffic"
  }
}

resource "aws_elasticache_parameter_group" "group" {
  name   = var.parameter_group_name
  family = "redis3.2"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }

  parameter {
    name  = "min-slaves-to-write"
    value = "2"
  }
}
