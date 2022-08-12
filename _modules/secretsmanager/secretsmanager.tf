resource "aws_secretsmanager_secret" "secretsmanager" {
  name = var.name
}
