output "config_bucket" {
  value = "${aws_s3_bucket.rancher-bucket.bucket}"
}

output "shudder_sqs_url" {
  value = "${aws_sqs_queue.rancher-terminations.id}"
}

output "external_security_group" {
  value = "${aws_security_group.rancher-sg.id}"
}

output "internal_security_group" {
  value = "${aws_security_group.rancher-internal-sg.id}"
}

output "rancher_hostname" {
  value = "${var.rancher_hostname}"
}

output "deployment_id" {
  value = "${var.deployment_id}"
}

output "status_endpoint" {
  value = "${aws_s3_bucket.rancher-status-bucket.website_endpoint}"
}

output "elb" {
  value = "${aws_elb.rancher-elb.id}"
}

output "instance_profile" {
  value = "${aws_iam_instance_profile.rancher-ec2-iam-profile.id}"
}

output "user_data" {
  value = "${data.template_file.rancher-userdata-template.rendered}"
}
