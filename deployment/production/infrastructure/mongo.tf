resource "aws_security_group" "rancher-production-mongo-sg" {
  name = "rancher-finboxio-production-mongo-host-sg"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "mongo1" {
  source = "../../../modules/host-fleet"
  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "mongo1"
  type = "cattle"

  spot_pools = "${var.mongo1_spot_pools}"

  cluster_size = "1"
  spot_allocation = "lowestPrice"
  spot_price = 0.2
  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  host_security_group = "${aws_security_group.rancher-production-mongo-sg.id}"
  server_security_group = "${var.server_security_group}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"

  version = "${var.version}"
  ami = "${var.ami}"
}

module "mongo2" {
  source = "../../../modules/host-fleet"
  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "mongo2"
  type = "cattle"

  spot_pools = "${var.mongo2_spot_pools}"

  cluster_size = "1"
  spot_allocation = "lowestPrice"
  spot_price = 0.2
  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  host_security_group = "${aws_security_group.rancher-production-mongo-sg.id}"
  server_security_group = "${var.server_security_group}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"

  version = "${var.version}"
  ami = "${var.ami}"
}
