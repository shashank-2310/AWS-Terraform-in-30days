resource "aws_instance" "example" {
  ami           = "ami-0912f71e06545ad88"
  count = var.instance_count

  # Conditional expression
  instance_type = var.environment == "dev" ? "t2.micro" : "t3.micro"

  tags = var.tags
}

resource "aws_security_group" "ingress_rules" {
  name   = "sg"

  # Dynamic block
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      protocol  = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }    
  }
  egress  = []
}

locals {
  # Splat expression
  all_instance_ids = aws_instance.example[*].id
}

output "instances" {
  value = local.all_instance_ids
}