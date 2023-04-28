// VPC.
resource "aws_vpc" "vpc" {
  cidr_block                           = var.vpc_cidr
  instance_tenancy                     = "default"
  enable_dns_support                   = true
  enable_network_address_usage_metrics = true
  enable_dns_hostnames                 = true
}

// VPC Subnets.
resource "aws_subnet" "dmz_0000001" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "dmz_0000002" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "dmz_0000003" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2c"
}

resource "aws_subnet" "semi_private_0000001" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "semi_private_0000002" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "semi_private_0000003" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-2c"
}

resource "aws_subnet" "private_0000001" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_0000002" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.21.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_0000003" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.22.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "database_0000001" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.30.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "database_0000002" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.31.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "database_0000003" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.32.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = false
}

// ingress-only Internet Gateway, route table, and subnet associations.
resource "aws_internet_gateway" "public_internet_internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_internet_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_internet_gateway.id
  }
}

resource "aws_route_table_association" "public_internet_route_table_association_0000001" {
  route_table_id = aws_route_table.public_internet_route_table.id
  subnet_id      = aws_subnet.dmz_0000001.id
}

resource "aws_route_table_association" "public_internet_route_table_association_0000002" {
  route_table_id = aws_route_table.public_internet_route_table.id
  subnet_id      = aws_subnet.dmz_0000002.id
}

resource "aws_route_table_association" "public_internet_route_table_association_0000003" {
  route_table_id = aws_route_table.public_internet_route_table.id
  subnet_id      = aws_subnet.dmz_0000003.id
}

// Security group for DMZ allowing inbound HTTP(S) traffic.
resource "aws_security_group" "dmz" {
  name        = "dmz"
  description = "Allow inbound HTTP(S) traffic."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// egress-only Internet Gateway, route table, and semi-private subnet associations.
resource "aws_internet_gateway" "semi_private_internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "semi_private_internet_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.semi_private_internet_gateway.id
  }
}

resource "aws_route_table_association" "semi_private_internet_route_table_association_0000001" {
  route_table_id = aws_route_table.semi_private_internet_route_table.id
  subnet_id      = aws_subnet.semi_private_0000001.id
}

resource "aws_route_table_association" "semi_private_internet_route_table_association_0000002" {
  route_table_id = aws_route_table.semi_private_internet_route_table.id
  subnet_id      = aws_subnet.semi_private_0000002.id
}

resource "aws_route_table_association" "semi_private_internet_route_table_association_0000003" {
  route_table_id = aws_route_table.semi_private_internet_route_table.id
  subnet_id      = aws_subnet.semi_private_0000003.id
}

// Security group for semi-private subnets permitting inbound and outbound HTTP(S) traffic.
resource "aws_security_group" "semi_private" {
  name        = "semi-private"
  description = "Allow outbound traffic."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from-DMZ-HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  }

  ingress {
    description = "from-DMZ-HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  }

  egress {
    description = "to-public-internet-HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "to-public-internet-HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow-all-outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// ingress/egress to private subnets via semi-private subnets only.
resource "aws_route_table" "private_internal_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "private_internal_route_table_association_0000001" {
  route_table_id = aws_route_table.private_internal_route_table.id
  subnet_id      = aws_subnet.private_0000001.id
}

resource "aws_route_table_association" "private_internal_route_table_association_0000002" {
  route_table_id = aws_route_table.private_internal_route_table.id
  subnet_id      = aws_subnet.private_0000002.id
}

resource "aws_route_table_association" "private_internal_route_table_association_0000003" {
  route_table_id = aws_route_table.private_internal_route_table.id
  subnet_id      = aws_subnet.private_0000003.id
}

// Security group for private subnets permitting inbound and outbound HTTP(S) traffic.
resource "aws_security_group" "private" {
  name        = "private"
  description = "Allow inbound traffic from semi-private only."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from-semi-private-HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  }

  ingress {
    description = "from-semi-private-HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  }

  egress {
    description = "to-semi-private-HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  }

  egress {
    description = "to-semi-private-HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  }

  egress {
    description = "from-private-to-database-postgresql"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
  }

  egress {
    description = "from-private-to-database-mysql-mariadb"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
  }

  egress {
    description = "from-private-to-mssql"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
  }
}

// ingress/egress to private subnets via semi-private subnets only.
resource "aws_route_table" "database_internal_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "database_internal_route_table_association_0000001" {
  route_table_id = aws_route_table.database_internal_route_table.id
  subnet_id      = aws_subnet.database_0000001.id
}

resource "aws_route_table_association" "database_internal_route_table_association_0000002" {
  route_table_id = aws_route_table.database_internal_route_table.id
  subnet_id      = aws_subnet.database_0000002.id
}

resource "aws_route_table_association" "database_internal_route_table_association_0000003" {
  route_table_id = aws_route_table.database_internal_route_table.id
  subnet_id      = aws_subnet.database_0000003.id
}

// Security group for database subnets permitting inbound traffic from private subnets only.
resource "aws_security_group" "database" {
  name        = "database"
  description = "Allow inbound traffic from private only."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from-private-HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  }

  ingress {
    description = "from-private-HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  }

  ingress {
    description = "from-private-postgresql"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  }

  ingress {
    description = "from-private-mysql-mariadb"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  }

  ingress {
    description = "from-private-mssql"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  }
}
