variable "rancher-amis" {
  type = "map"
  default = {
    ap-northeast-1 = "ami-a452a2c5"
    ap-northeast-2 = "ami-928e44fc"
    ap-southeast-1 = "ami-529f4231"
    ap-southeast-2 = "ami-fc577c9f"
    eu-central-1 = "ami-4a7f9425"
    eu-west-1 = "ami-997b1eea"
    sa-east-1 = "ami-98198cf4"
    us-east-1 = "ami-1071ca07"
    us-west-1 = "ami-a57730c5"
    us-west-2 = "ami-f0f03190"
    ap-south-1 = "ami-de97fdb1"
  }
}

data "atlas_artifact" "rancher-aws-server" {
  name = "finboxio/rancher-aws-server"
  type = "amazon.image"
  version = "${replace(var.version, "latest", "")}"
  metadata {
    region = "${var.region}"
  }
}

data "atlas_artifact" "rancher-aws-host" {
  name = "finboxio/rancher-aws-host"
  type = "amazon.image"
  version = "${replace(var.version, "latest", "")}"
  metadata {
    region = "${var.region}"
  }
}

module "server" {
  source = "../modules/server-asg"

  deployment_id = "${var.deployment_id}"
  version = "${coalesce(var.version, "${data.atlas_artifact.rancher-aws-server.metadata_full.version}${replace(var.use_latest, "/.+/", "-latest")}")}"
  ami = "${element(split(",", data.atlas_artifact.rancher-aws-server.metadata_full.ami_id), index(split(",", data.atlas_artifact.rancher-aws-server.metadata_full.region), var.region))}"

  region = "${var.region}"
  ssh_keypair = "${var.ssh_keypair}"
  zone_id = "${var.zone_id}"
  certificate_id = "${var.certificate_id}"
  cloudfront_certificate_id = "${var.cloudfront_certificate_id}"

  cluster_size = "${var.server_nodes}"
  instance_type = "${var.server_instance_type}"
  spot_price = "${var.server_spot_price}"
  availability_zones = "${var.server_availability_zones}"

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

output "status_endpoint" {
  value = "${module.server.status_endpoint}"
}

module "staging" {
  source = "./staging/infrastructure"

  name = "Staging"
  deployment_id = "${module.server.deployment_id}"
  version = "${coalesce(var.version, "${data.atlas_artifact.rancher-aws-server.metadata_full.version}${replace(var.use_latest, "/.+/", "-latest")}")}"
  ami = "${element(split(",", data.atlas_artifact.rancher-aws-host.metadata_full.ami_id), index(split(",", data.atlas_artifact.rancher-aws-host.metadata_full.region), var.region))}"

  rancher_hostname = "${module.server.rancher_hostname}"
  cluster_size = "${var.staging_default_nodes}"
  instance_type = "${var.staging_default_instance_type}"
  availability_zones = "${var.staging_default_availability_zones}"

  shudder_sqs_url = "${module.server.shudder_sqs_url}"
  s3_bucket = "${module.server.s3_bucket}"
  server_sg = "${module.server.internal_security_group}"
}
