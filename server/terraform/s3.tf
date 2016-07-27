resource "aws_s3_bucket" "rancher-bucket" {
  bucket        = "${var.deployment_id}-rancher-config"
  force_destroy = true
}
