output "region" {
  value = var.region
}

output "project_name" {
  value = var.project-name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2
}

output "private_app_subnet_az1_id" {
  value = aws_subnet.private_app_subnet_az1.id
}

output "private_app_subnet_az2_id" {
  value = aws_subnet.private_app_subnet_az2
}

output "private_db_subnet_az1_id" {
  value = aws_subnet.private_db_subnet_az1.id
}

output "private_db_subnet_az2_id" {
  value = aws_subnet.private_db_subnet_az2
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}