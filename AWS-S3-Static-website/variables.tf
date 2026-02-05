variable "Region" {
    description = "AWS region to deploy the S3 static website"
    type        = string
    default     = "us-east-1"
}

variable "s3-bucket-name" {
    description = "The name of the S3 bucket to host the static website"
    type        = string
    default     = "my-static-website-bucket-12345"
  
}