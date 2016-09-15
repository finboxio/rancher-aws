resource "aws_security_group" "rancher-production-monitoring-sg" {
  name = "rancher-finboxio-production-monitoring-host-sg"

  ingress {
    from_port = 9109
    to_port = 9109
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "monitoring" {
  source = "../../../modules/host-fleet"

  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "monitoring"
  type = "cattle"
  version = "${var.version}"
  ami = "${var.ami}"

  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  server_security_group = "${var.server_security_group}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"
  slack_channel = "${var.slack_channel}"

  host_security_group = "${aws_security_group.rancher-production-monitoring-sg.id}"
  cluster_size = "${var.monitoring_nodes}"
  spot_pools = "${var.monitoring_spot_pools}"
  spot_allocation = "${var.monitoring_spot_allocation}"
  spot_price = "${var.monitoring_spot_price}"
}
