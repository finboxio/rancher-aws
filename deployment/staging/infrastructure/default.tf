module "default" {
  source = "../../../modules/host-asg"

  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "default"
  type = "cattle"

  region = "${var.region}"
  availability_zones = "${var.availability_zones}"
  cluster_size = "${var.cluster_size}"
  instance_type = "${var.instance_type}"
  spot_price = "${var.spot_price}"
  ssh_keypair = "${var.ssh_keypair}"
  zone_id = "${var.zone_id}"
  certificate_id = "${var.certificate_id}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  s3_bucket = "${var.s3_bucket}"
  server_sg = "${var.server_sg}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"

  version = "${var.version}"
  ami = "${var.ami}"
}
