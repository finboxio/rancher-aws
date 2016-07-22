resource "template_file" "rancher-userdata-template" {
  template = "${file("templates/cloud-config.yml")}"

  vars {
    mysql_root_password    = "${var.mysql_root_password}"
    rancher_mysql_database = "${var.rancher_mysql_database}"
    rancher_mysql_user     = "${var.rancher_mysql_user}"
    rancher_mysql_password = "${var.rancher_mysql_password}"
    rancher_admin_user     = "${var.rancher_admin_user}"
    rancher_admin_password = "${var.rancher_admin_password}"
    rancher_url            = "${var.rancher_url}"
    rancher_s3_bucket      = "${aws_s3_bucket.rancher-bucket.bucket}"
    slack_webhook          = "${var.slack_webhook}"
    shudder_sns_topic      = "${aws_sns_topic.rancher-terminations.arn}"
    shudder_sqs_prefix     = "${var.deployment_id}"
    cluster_size           = "${var.cluster_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "rancher-lc" {
  image_id             = "ami-f0f03190"
  name_prefix          = "${var.deployment_id}-rancher-"
  instance_type        = "${var.instance_type}"
  spot_price           = "${var.spot_price}"
  key_name             = "${var.ssh_keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.rancher-ec2-iam-profile.id}"

  security_groups = [
    "${aws_security_group.rancher-sg.id}",
    "${aws_security_group.rancher-internal-sg.id}",
  ]

  ebs_optimized     = "${var.ebs_optimized}"
  enable_monitoring = false
  user_data         = "${template_file.rancher-userdata-template.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}
