output "rancher_hostname" {
  value = "${var.rancher_hostname}"
}

output "deployment_id" {
  value = "${var.deployment_id}"
}

output "config_bucket" {
  value = "${module.base.config_bucket}"
}

output "status_endpoint" {
  value = "${module.base.status_endpoint}"
}

output "shudder_sqs_url" {
  value = "${module.base.shudder_sqs_url}"
}

output "internal_security_group" {
  value = "${module.base.internal_security_group}"
}
