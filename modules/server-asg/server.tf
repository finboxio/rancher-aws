module "base" {
  source = "../server-base"
  deployment_id = "${var.deployment_id}"

  region = "${var.region}"
  availability_zones = "${var.availability_zones}"
  instance_type = "${var.instance_type}"
  spot_price = "${var.spot_price}"
  ebs_optimized = "${var.ebs_optimized}"
  cluster_size = "${var.cluster_size}"
  ssh_keypair = "${var.ssh_keypair}"
  zone_id = "${var.zone_id}"
  certificate_id = "${var.certificate_id}"
  cloudfront_certificate_id = "${var.cloudfront_certificate_id}"

  ami = "${var.ami}"
  version = "${var.version}"

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
