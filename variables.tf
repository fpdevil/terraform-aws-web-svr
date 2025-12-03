variable "ami_id" {
  description = "The AMI ID base image for the EC2 to be bootstrapped"
  type        = string
  default     = "ami-0f5fcdfbd140e4ab7"
}

variable "instance_type" {
  description = "Type of the EC2 instance: micro | small | medium | large..."
  type        = string
  default     = "t2.micro"
}

variable "region" {
  description = "AWS region where the infra needs to be provisioned"
  type        = string
  default     = "us-east-2"
}

variable "availability_zone" {
  description = "Zone where the instance is made avaialble within the region"
  type        = string
  default     = "us-east-2c"
}

# security group name to be provided as input
# can be passed as below
# export TF_VAR_security_group_name=meaningful value
variable "security_group_name" {
  description = "The name for security group"
  type        = string
  default     = "WebServerSecurityGroup"
}
