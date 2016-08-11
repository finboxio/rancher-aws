module "default" {
  source = "../../../modules/host-fleet"

  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "default"
  type = "cattle"

  cluster_size = "${var.cluster_size}"
  spot_pools = "${var.spot_pools}"
  spot_allocation = "${var.spot_allocation}"
  spot_price = "${var.spot_price}"
  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  host_security_group = "${aws_security_group.rancher-host-sg.id}"
  server_security_group = "${var.server_security_group}"
  elb_name = "${aws_elb.rancher-elb.name}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"

  version = "${var.version}"
  ami = "${var.ami}"
}
