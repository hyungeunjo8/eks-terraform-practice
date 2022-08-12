resource "aws_dynamodb_table" "dynamodb" {
  name           = var.name
  read_capacity  = 0
  write_capacity = 0
  billing_mode   = "PAY_PER_REQUEST"

  hash_key = "instanceId"

  attribute {
    name = "instanceId"
    type = "S"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"
}

resource "aws_vpc_endpoint_route_table_association" "dynamo_endpoint_routetable" {
  count           = length(var.vpc_private_route_table_ids)
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = var.vpc_private_route_table_ids[count.index]
}
