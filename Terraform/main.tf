# Create vpc
resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block
    tags = {
      Name = var.vpc_name
    }
}

# Create subnet in each AZ
resource "aws_subnet" "my_subnet" {
    count = length(var.availability_zones)
    cidr_block = "10.0.${count.index + 1}.0/24"
    vpc_id = aws_vpc.my_vpc.id
    availability_zone = element(var.availability_zones, count.index)
    tags = {
      Name = "My Subnet ${count.index + 1}"
    }
}

resource "" "name" {
  
}