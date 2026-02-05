# Configure the S3 backend for Terraform state storage 
terraform {
  backend "s3" {
    bucket = "lokibucket1994"
    key    = "terraform/aws-terraform-state-s3-static-website"
    region = "us-east-2"
    use_lockfile = true
  }
}