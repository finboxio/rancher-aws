variable "deployment_id" {}
variable "region" {}
variable "availability_zones" {}
variable "cluster_size" {}
variable "instance_type" {}
variable "spot_price" {}
variable "ssh_keypair" {}
variable "zone_id" {}
variable "certificate_id" {}
variable "rancher_hostname" {}
variable "mysql_root_password" {}
variable "mysql_volume_size" {}
variable "rancher_mysql_user" {}
variable "rancher_mysql_password" {}
variable "rancher_mysql_database" {}
variable "rancher_admin_user" {}
variable "rancher_admin_password" {}
variable "slack_webhook" {}

module "server" {
  source = "./modules/server/terraform"

  deployment_id = "${var.deployment_id}"

  region = "${var.region}"
  availability_zones = "${var.availability_zones}"
  cluster_size = "${var.cluster_size}"
  instance_type = "${var.instance_type}"
  spot_price = "${var.spot_price}"
  ssh_keypair = "${var.ssh_keypair}"
  zone_id = "${var.zone_id}"
  certificate_id = "${var.certificate_id}"

  rancher_hostname = "${var.rancher_hostname}"
  mysql_root_password = "${var.mysql_root_password}"
  mysql_volume_size = "${var.mysql_volume_size}"
  rancher_mysql_user = "${var.rancher_mysql_user}"
  rancher_mysql_password = "${var.rancher_mysql_password}"
  rancher_mysql_database = "${var.rancher_mysql_database}"
  rancher_admin_user = "${var.rancher_admin_user}"
  rancher_admin_password = "${var.rancher_admin_password}"
  slack_webhook = "${var.slack_webhook}"
}

module "staging" {
  source = "./environments/staging/infrastructure"

  name = "Staging"
  deployment_id = "${module.server.deployment_id}"
  sqs_queue = "${module.server.sqs_queue}"
  s3_bucket = "${module.server.s3_bucket}"
  server_sg = "${module.server.security_group}"
  rancher_hostname = "${module.server.rancher_hostname}"
}
