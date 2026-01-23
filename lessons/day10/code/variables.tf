variable "environment" {
    default = "preprod"
    type = string
}

variable "region" {
  default = "ap-south-1"
  type = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "allowed_vm_types" {
  description = "List of allowed VM types"
  type       = list(string)
  default    = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable "tags" {
  type = map(string)
  default = {
      Name = "dev-demo-ec2"
      Environment = "dev"
      CreatedBy = "Terraform"
  }
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "http"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP access"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "https"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS access"
    }
  ]
}