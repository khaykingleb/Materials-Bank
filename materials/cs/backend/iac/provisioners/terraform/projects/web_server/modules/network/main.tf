terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = "~> 4.0"
  }
}

##@ Virtual Private Cloud

resource "aws_vpc" "this" {
  cidr_block = "${var.cidr_base}.0.0/16"

  tags = merge(var.tags, { "name" = "${var.environment}-vpc" })
}

##@ Subnets

resource "aws_subnet" "public" {
  count                   = var.subnets_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${var.cidr_base}.${count.index + 10}.0/28" # 11 hosts
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, { "name" = "${var.environment}-public-subnet-${count.index + 1}" })
}


resource "aws_subnet" "private" {
  count                   = var.subnets_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "${var.cidr_base}.${count.index + 20}.0/28" # 251 hosts
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, { "name" = "${var.environment}-private-subnet-${count.index + 1}" })
}

##@ Internet Gateway

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { "name" = "${var.environment}-igw" })
}

##@ Elastic IPs

resource "aws_eip" "nat_eip" {
  count = var.subnets_count

  tags = merge(var.tags, { "name" = "${var.environment}-nat-eip-${count.index + 1}" })
}

##@ NAT Gateways

resource "aws_nat_gateway" "this" {
  count         = var.subnets_count
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, { "name" = "${var.environment}-nat-gateway-${count.index + 1}" })
}

##@ Route Tables

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, { "name" = "${var.environment}-route-table-to-igw" })
}

resource "aws_route_table" "nat" {
  count  = var.subnets_count
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { "name" = "${var.environment}-route-table-${count.index + 1}-to-nat" })
}

resource "aws_route_table_association" "public_az" {
  count          = var.subnets_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "private_az" {
  count          = var.subnets_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.nat[count.index].id
}
