resource "aws_instance" "RM" {
  ami = "ami-0cc9838aa7ab1dce7"
  key_name = "terra-key1"
  instance_type = "t2.micro"
  
  tags = {
    Name = "terraform-ec2"
  }

}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Default subnet for us-west-2a"
  }
}
