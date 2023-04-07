# Create vpc
resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block
    tags = {
      Name = var.vpc_name
    }
}

# Create Public and Private subnets in each AZ
resource "aws_subnet" "Public_subnet" {
    count = 2
    //count = length(var.availability_zones)
    cidr_block = "10.0.${count.index + 1}.0/24"
    vpc_id = aws_vpc.my_vpc.id
    //availability_zone = element(var.availability_zones, count.index)
    tags = {
      Name = "Public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "Private_subnet" {
    count = 2
    //count = length(var.availability_zones)
    cidr_block = "10.0.${count.index + 3}.0/24"
    vpc_id = aws_vpc.my_vpc.id
    //availability_zone = element(var.availability_zones, count.index)
    tags = {
      Name = "Private-subnet-${count.index + 1}"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = "my-igw"
    }
}

# Create Nat Gateway
resource "aws_nat_gateway" "Nat-gw" {
    count = 2
    allocation_id = aws_eip.eip[count.index + 1].id
    subnet_id = aws_subnet.Private_subnet[count.index].id
    tags = {
      Name = "nat-gateway-${count.index +1}"
    }
}


# Route table for Public and Private subnets
resource "aws_route_table" "PublicRT" {
    vpc_id = aws_vpc.my_vpc.id
    route = {
        cidr_block ="0.0.0.0/0"
        gateway_id = 
    }
}

resource "aws_route_table" "PrivateRT" {
    vpc_id = aws_vpc.my_vpc.id
    route = {
        cidr_block ="0.0.0.0/0"
        nat_gateway_id = 
    }
}