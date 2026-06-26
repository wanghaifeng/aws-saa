terraform {
  backend "s3" {
    bucket         = "aws-saa-practice-state-freetrial"
    key            = "aws/environments/freetrial/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "aws-saa-practice-terraform-state-lock"
    encrypt        = true
  }
}
