# Configure the S3 backend for Terraform state storage 
terraform {
  backend "s3" {
    bucket = "******bucketname******"
    key    = "terraform/aws-terraform-state-files"
    region = "us-east-2"
    use_lockfile = true
  }
}
