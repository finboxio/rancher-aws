variable "name" {}

variable "deployment_id" {}
variable "sqs_queue" {}
variable "s3_bucket" {}
variable "server_sg" {}
variable "rancher_hostname" {}

variable "ssh_keypair" {}
variable "zone_id" {}
variable "certificate_id" {}

variable "region" {}
variable "availability_zones" {}
variable "cluster_size" {}
variable "instance_type" {}
variable "spot_price" {}

variable "slack_webhook" {}

module "default" {
  source = "../../../modules/environment/terraform"

  deployment_id = "${var.deployment_id}"
  name = "${var.name}"
  type = "cattle"

  region = "${var.region}"
  availability_zones = "${var.availability_zones}"
  cluster_size = "${var.cluster_size}"
  instance_type = "${var.instance_type}"
  spot_price = "${var.spot_price}"
  ssh_keypair = "${var.ssh_keypair}"
  zone_id = "${var.zone_id}"
  certificate_id = "${var.certificate_id}"
  sqs_queue = "${var.sqs_queue}"
  s3_bucket = "${var.s3_bucket}"
  server_sg = "${var.server_sg}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"
}
