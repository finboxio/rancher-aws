module "hosts" {
  source = "../host-base"

  deployment_id = "${var.deployment_id}"
  rancher_hostname = "${var.rancher_hostname}"
  environment = "${var.environment}"
  group = "${var.group}"
  type = "${var.type}"

  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  server_security_group = "${var.server_security_group}"
  elb_name = "${var.elb_name}"

  slack_webhook = "${var.slack_webhook}"
  slack_channel = "${var.slack_channel}"
  slack_username = "${var.slack_username}"
  slack_icon = "${var.slack_icon}"
  version = "${var.version}"
}
