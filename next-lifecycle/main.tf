resource "aws_instance" "import" {
  ami               = "ami-0cc9838aa7ab1dce7"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "terra-key1"

  tags = {
    Name = "Hii"
  }

  # below are the examples of lifecycle rules


  #this attribute will create the new object first and then destroy the old one

  #   lifecycle {
  #     create_before_destroy = true
  #   }


  # terrafrom will give error when try to destroy the resource when this is set to true

  #   lifecycle {
  #     prevent_destroy = true  
  #   }


  #This means that Terraform will never update the object but will be able to create or destroy it.
  # lifecycle {
  #   ignore_changes = [tags,] 
  # }

}



