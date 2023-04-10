# Create vpc
resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
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
    map_public_ip_on_launch = true
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
    map_public_ip_on_launch = false
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

# Create Elastic ip before creating Nat gateway
resource "aws_eip" "Nateip" {
    //vpc = true
    count = 2
    tags = {
      "Name" = "Nateip-${count.index +1}"
    }
}


# Create Nat Gateway
resource "aws_nat_gateway" "Natgw" {
    count = 2
    allocation_id = aws_eip.Nateip[count.index + 1].id
    subnet_id = aws_subnet.Private_subnet[count.index].id
    tags = {
      Name = "nat-gateway-${count.index +1}"
    }
}

# Elastic ip associaton
resource "aws_eip_association" "nat_eip_association" {
    count = 2
    eip = aws_eip.Nateip[count.index].id
    instance = aws_nat_gateway.Natgw.id 
}


# Create Route table for Public and Private subnets
resource "aws_route_table" "PublicRT" {
    vpc_id = aws_vpc.my_vpc.id
    route = {
        cidr_block ="0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table" "PrivateRT" {
    vpc_id = aws_vpc.my_vpc.id
    route = {
        cidr_block ="0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.Natgw.id
    }
}

# Route table associations with Private and Public subnets
resource "aws_route_table_association" "publicRTassociation" {
    subnet_id = aws_subnet.Public_subnet.id
    route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "privateRTassociation" {
    subnet_id = aws_subnet.Private_subnet.id
    route_table_id = aws_route_table.PrivateRT.id
}