resource "aws_security_group" "rancher-production-prerender-sg" {
  name = "rancher-finboxio-production-prerender-host-sg"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "prerender" {
  source = "../../../modules/host-fleet"
  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "prerender"
  type = "cattle"

  spot_pools = "${var.prerender_spot_pools}"

  cluster_size = "${var.prerender_cluster_size}"
  spot_allocation = "lowestPrice"
  spot_price = "${var.spot_price}"
  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  host_security_group = "${aws_security_group.rancher-production-prerender-sg.id}"
  server_security_group = "${var.server_security_group}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"
  slack_channel = "${var.slack_channel}"

  version = "${var.version}"
  ami = "${var.ami}"
}
