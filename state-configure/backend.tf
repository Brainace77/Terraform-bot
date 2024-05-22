terraform {
  backend "s3" {
    bucket = "update-statefile"
    key = "d4/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-lock-dynamo" #Dynamo DB table used for state locking
    encrypt = true # Ensures the state is encrypted at rest s3
    
  }
}