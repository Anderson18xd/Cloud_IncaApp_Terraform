terraform {
  backend "s3" {
    bucket       = "ander-tfstate-boveda-2026"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}