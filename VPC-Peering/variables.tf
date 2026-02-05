variable "primary" {
    description = "AWS region for primary VPC"
    type        = string
    default     = "us-east-2"
}

variable "secondary" {
    description = "AWS region for secondary VPC"
    type        = string
    default     = "us-west-2"
}

variable "primary_vpc_cidr" {
    default = "10.0.0.0/16"
}
variable "secondary_vpc_cidr" {
    default = "10.1.0.0/16"
}
