#############################
# Public Subnet 1
#############################

resource "aws_subnet" "public_subnet_1" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1"

    "kubernetes.io/role/elb" = "1"
  }
}

#############################
# Public Subnet 2
#############################

resource "aws_subnet" "public_subnet_2" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2"

    "kubernetes.io/role/elb" = "1"
  }
}
