output "instance_profile" {
  value = "${aws_iam_instance_profile.rancher-ec2-iam-profile.id}"
}

output "user_data" {
  value = "${data.template_file.rancher-userdata-template.rendered}"
}

output "external_security_group" {
  value = "${aws_security_group.rancher-sg.id}"
}

output "rancher_hostname" {
  value = "${var.rancher_hostname}"
}

output "deployment_id" {
  value = "${var.deployment_id}"
}
