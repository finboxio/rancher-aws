data "template_file" "rancher-userdata-template" {
  template = "${file(format("%s/%s", path.module, "templates/cloud-config.yml"))}"

  vars {
    deployment_id          = "${var.deployment_id}"
    environment_name       = "${var.environment}"
    environment_group      = "${var.group}"
    environment_type       = "${var.type}"
    rancher_hostname       = "${var.rancher_hostname}"
    shudder_sqs_url        = "${var.shudder_sqs_url}"
    config_bucket          = "${var.config_bucket}"
    elb_name               = "${var.elb_name}"
    slack_webhook          = "${var.slack_webhook}"
    version                = "${var.version}"
  }
}
