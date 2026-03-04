terraform {
  backend "s3" {
    bucket = "skdevops-terraform-state" # Change to your unique bucket name
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
}