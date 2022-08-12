resource "aws_sqs_queue" "queue" {
  name       = var.name
  fifo_queue = true
}
