resource "aws_vpc" "primary-vpc" {
  cidr_block           = var.primary_vpc_cidr
  provider             = aws.primary
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "Primary-VPC-${var.primary}"
  }
}

resource "aws_vpc" "secondary-vpc" {
  cidr_block           = var.secondary_vpc_cidr
  provider             = aws.secondary
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy = "default"

  tags = {
    Name = "Secondary-VPC-${var.secondary}"
  }
}

resource "aws_subnet" "primary-subnet" {
  provider            = aws.primary
  vpc_id              = aws_vpc.primary-vpc.id
  cidr_block          = var.primary_vpc_cidr
  availability_zone   = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Primary-Subnet-${var.primary}"
    Environment = "Demo"
  }
}

resource "aws_subnet" "secondary-subnet" {
  provider            = aws.secondary
  vpc_id              = aws_vpc.secondary-vpc.id
  cidr_block          = var.secondary_vpc_cidr
  availability_zone   = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Secondary-Subnet-${var.secondary}"
    Environment = "Demo"
  }
}

resource "aws_internet_gateway" "primary-igw" {
  provider = aws.primary
  vpc_id = aws_vpc.primary-vpc.id

  tags = {
    Name = "Primary-igw-${var.primary}"
    Environment = "Demo"
  }
}

resource "aws_internet_gateway" "secondary-igw" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary-vpc.id

  tags = {
    Name = "Secondary-igw-${var.secondary}"
    Environment = "Demo"
  }
}


resource "aws_route_table" "primary-route-table" {
  provider = aws.primary
  vpc_id = aws_vpc.primary-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary-igw.id
  }


  tags = {
    Name = "Primary-Route-Table-${var.primary}"
    Environment = "Demo"
  }
}

resource "aws_route_table" "secondary-route-table" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary-igw.id
  }


  tags = {
    Name = "Secondary-Route-Table-${var.secondary}"
    Environment = "Demo"
  }
}

resource "aws_route_table_association" "primary-rta" { 
  provider       = aws.primary 
  subnet_id      = aws_subnet.primary-subnet.id
  route_table_id = aws_route_table.primary-route-table.id
}

resource "aws_route_table_association" "secondary-rta" { 
  provider       = aws.secondary 
  subnet_id      = aws_subnet.secondary-subnet.id
  route_table_id = aws_route_table.secondary-route-table.id
}

# VPC Peering Connection (Requester side - Primary VPC)
resource "aws_vpc_peering_connection" "primary-to-secondary" {
  provider      = aws.primary
  vpc_id        = aws_vpc.primary-vpc.id
  peer_vpc_id   = aws_vpc.secondary-vpc.id
  peer_region   = var.secondary 
  
  auto_accept   = false

  tags = {
    Name = "VPC Peering between primary and secondary"
  }
}

# VPC Peering Connection Accepter (Accepter side - Secondary VPC)
resource "aws_vpc_peering_connection_accepter" "secondary-accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary-to-secondary.id
  auto_accept               = true

  tags = {
    Name        = "Secondary-Peering-Accepter"
    Environment = "Demo"
    Side        = "Accepter"
  }
}


resource "aws_route" "primary-to-secondary-route" {
  provider                   = aws.primary
  route_table_id             = aws_route_table.primary-route-table.id
  destination_cidr_block     = var.secondary_vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.primary-to-secondary.id
  
  depends_on = [ aws_vpc_peering_connection_accepter.secondary-accepter ]
}

# Add route to Primary VPC in Secondary route table
resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary-route-table.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary-to-secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary-accepter]
}