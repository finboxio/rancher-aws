resource "aws_security_group" "rancher-staging-mongo-sg" {
  name = "rancher-finboxio-staging-mongo-host-sg"

  ingress {
    from_port = 32810
    to_port = 32810
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

module "mongo" {
  source = "../../../modules/host-fleet"
  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "mongo"
  type = "cattle"

  spot_pools = "${var.mongo_spot_pools}"

  cluster_size = "1"
  spot_allocation = "diversified"
  spot_price = "${var.spot_price}"
  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  host_security_group = "${aws_security_group.rancher-staging-mongo-sg.id}"
  server_security_group = "${var.server_security_group}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"
  slack_channel = "${var.slack_channel}"

  version = "${var.version}"
  ami = "${var.ami}"
}
