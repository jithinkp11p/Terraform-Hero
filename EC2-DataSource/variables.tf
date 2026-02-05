# first type constraint - number 
variable "Instance_count" {
  type = number
  default = 1
}

# second type constraint - string
variable "Region" {
  description = "Region i am choosing"
  type        = string
  default     = "us-east-1"
}

# third type constraint - Boolean
variable "public_ip" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = true
}

# fourth type constraint - list
variable "cidr_block" {
  description = "value"
  type        = list(string)
  default     = ["10.0.0.0/16","192.168.0.0/16"]
}

# fifth type constraint - set
variable "allowed_region" {
  description = "List of allowed region"
  type        = set(string)
  default     = ["us-east-1","us-west-2","eu-west-1"]
}

# sixth type constraint - map
variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {
    Environment = "staging"
    Project     = "EC2-Setup"
    Name        = "staging-EC2-Instance"
  }
  
}


# Input Variables - Values provided to Terraform configuration
variable "Environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "My Test Project"
}

# Used to test merge function with maps
variable "default_tags" {
  description = "Default tags for resources"
  type        = map(string)
  default     = {
    Owner       = "Admin"
    Department  = "IT"
    CostCenter  = "12345"
  }
}

variable "environment_tags" {
  description = "Environment-specific tags for resources"
  type        = map(string)
  default     = {
    Environment = "Dev"
  }
}
# checking split and for loop
variable "all_port_list" {
  default     = "22,80"
}

# checking vlidataion and condition 
variable "instance_type" {
  default = "t3.micro"
  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3a.micro"], var.instance_type)
    error_message = "Invalid instance type. Allowed types are t2.micro, t3.micro, t3a.micro."
  }
  validation {

  condition = length(var.instance_type) >= 3 && length(var.instance_type) <= 20
  error_message = "Instance type must be between 3 and 20 characters long."
  }
  
}