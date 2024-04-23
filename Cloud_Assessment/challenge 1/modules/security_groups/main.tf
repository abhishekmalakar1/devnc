provider "aws" {
  region = us-east-1
}

resource "aws_security_group" "frontend_sg" {
  vpc_id = aws_vpc.threetier.id
}

resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.threetier.id
}

resource "aws_security_group" "database_sg" {
  vpc_id = aws_vpc.threetier.id
}