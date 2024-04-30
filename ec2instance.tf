provider "aws" {
	region = "us-east-1"
}

resource "aws_instance" "demoec2" {
	ami = ""
	instance_type = "t2-micro"
	key_pair = ""
	count = 5
	tags = {
		name = "ec2-instance-${count.index + 1}"
	}
}