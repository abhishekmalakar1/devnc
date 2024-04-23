provider "aws" {
  region = us-east-1
}

resource "aws_subnet" "frontend_subnet" {
  vpc_id = aws_vpc.threetier.id 
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"  
}

resource "aws_subnet" "backend_subnet" {
  vpc_id = aws_vpc.threetier.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"  
}

resource "aws_subnet" "database_subnet" {
  vpc_id = aws_vpc.threetier.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"  
}
