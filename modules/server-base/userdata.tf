data "template_file" "rancher-userdata-template" {
  template = "${file(format("%s/%s", path.module, "templates/cloud-config.yml"))}"

  vars {
    deployment_id          = "${var.deployment_id}"
    mysql_root_password    = "${var.mysql_root_password}"
    mysql_volume_size      = "${var.mysql_volume_size}"
    rancher_mysql_database = "${var.rancher_mysql_database}"
    rancher_mysql_user     = "${var.rancher_mysql_user}"
    rancher_mysql_password = "${var.rancher_mysql_password}"
    rancher_admin_user     = "${var.rancher_admin_user}"
    rancher_admin_password = "${var.rancher_admin_password}"
    rancher_hostname       = "${var.rancher_hostname}"
    rancher_s3_bucket      = "${aws_s3_bucket.rancher-bucket.bucket}"
    rancher_status_bucket  = "${aws_s3_bucket.rancher-status-bucket.bucket}"
    slack_webhook          = "${var.slack_webhook}"
    shudder_sqs_url        = "${aws_sqs_queue.rancher-terminations.id}"
    cluster_size           = "${var.cluster_size}"
    elb_name               = "${aws_elb.rancher-elb.name}"
    version                = "${var.version}"
  }
}
