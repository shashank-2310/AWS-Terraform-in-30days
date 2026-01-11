# resource "aws_security_group" "app_sg" {
#   # name = "app-security-group"
#   name = "app-security-group-2"
#   # description = "Security group for application servers"
#   description = "NEW Security group for application servers"
# }

resource "aws_instance" "demo_ec2" {
  # ami = "ami-0912f71e06545ad88"
  ami = "ami-019715e0d74f695be"
  instance_type = var.allowed_vm_types[0]
  region = var.region
  tags = var.tags
  # vpc_security_group_ids = [ aws_security_group.app_sg.id ]

  lifecycle {
    create_before_destroy = true
    # ignore_changes = [ ami ]
    # prevent_destroy = true
    # replace_triggered_by = [ aws_security_group.app_sg.id ]
    # precondition {
    #   condition     = var.region == "ap-south-2"
    #   error_message = "variable 'region' must be 'ap-south-2'"
    # }
    # postcondition {
    #   condition = contains(keys(self.tags_all), "Compliance")
    #   error_message = "Tag 'Compliance' is required."
    # }
  }
}