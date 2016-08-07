resource "aws_s3_bucket" "rancher-bucket" {
  bucket        = "rancher-${lower(var.deployment_id)}-config"
  force_destroy = true
}

