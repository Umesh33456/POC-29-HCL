terraform {
  backend "s3" {
    bucket         = "terraform-poc-209"
    key            = "poc-29/demo.tfstate"
    region         = "us-east-1"
    #dynamodb_table = "terraform-locks"
  }
}