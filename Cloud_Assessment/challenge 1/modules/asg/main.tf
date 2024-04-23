provider "aws" {
  region = us-east-1
}

resource "aws_launch_configuration" "lc" {
  name = "frontend-lc"
  image_id = "ami-123abc"
  instance_type = "t2.large"
  security_groups = aws_security_group.frontend_sg.id 
  key_name = "key-name"
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.frontend_lc
  min_size = 2
  max_size = 5
  desired_capacity = 3
  vpc_zone_identifier = [ aws_subnet.frontend_subnet.id, aws_subnet.backend_subnet.id, aws_subnet.database_subnet.id ]
}