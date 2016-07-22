resource "aws_s3_bucket" "rancher-bucket" {
  bucket = "${var.deployment_id}-host-config"
  force_destroy = true
}

resource "template_file" "rancher-config-template" {
  template = "${file("templates/rancher.conf")}"
  vars {
    deployment_id = "${var.deployment_id}"
    rancher_url = "${var.rancher_url}"
    rancher_access_key_id = "${var.rancher_access_key_id}"
    rancher_secret_access_key = "${var.rancher_secret_access_key}"
    rancher_host_labels = "${var.rancher_host_labels}"
    region = "us-west-2"
  }
}

resource "aws_s3_bucket_object" "rancher-config" {
  key = "rancher.conf"
  bucket = "${aws_s3_bucket.rancher-bucket.bucket}"
  content = "${template_file.rancher-config-template.rendered}"
}
