data "template_file" "rancher-userdata-template" {
  template = "${file(format("%s/%s", path.module, "templates/cloud-config.yml"))}"

  vars {
    deployment_id          = "${var.deployment_id}"
    environment_name       = "${var.environment}"
    environment_group      = "${var.group}"
    environment_type       = "${var.type}"
    rancher_hostname       = "${var.rancher_hostname}"
    shudder_sqs_url        = "${var.shudder_sqs_url}"
    config_bucket              = "${var.config_bucket}"
    slack_webhook          = "${var.slack_webhook}"
    version                = "${var.version}"
  }
}

resource "aws_launch_configuration" "rancher-lc" {
  image_id             = "${var.ami}"
  name_prefix          = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-"
  instance_type        = "${var.instance_type}"
  spot_price           = "${var.spot_price}"
  key_name             = "${var.ssh_keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.rancher-ec2-iam-profile.id}"

  security_groups = [
    "${aws_security_group.rancher-sg.id}",
    "${var.server_sg}"
  ]

  ebs_optimized     = "${var.ebs_optimized}"
  enable_monitoring = false
  user_data         = "${data.template_file.rancher-userdata-template.rendered}"

  root_block_device = {
    volume_size = 16
  }

  lifecycle {
    create_before_destroy = true
  }
}
