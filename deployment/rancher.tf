data "atlas_artifact" "rancher-aws-server" {
  name = "finboxio/rancher-aws-server"
  type = "amazon.image"
  metadata {
    version = "${coalesce(var.server_ami_version, var.ami_version)}"
    region = "${var.region}"
  }
}

module "server" {
  source = "../modules/server-fleet"

  deployment_id = "${var.deployment_id}"

  rancher_server = "${var.rancher_server}"
  rancher_agent = "${var.rancher_agent}"

  version = "${coalesce(var.server_image_version, var.image_version, var.server_ami_version, var.ami_version, element(split(",", data.atlas_artifact.rancher-aws-server.metadata_full.ami_id), index(split(",", data.atlas_artifact.rancher-aws-server.metadata_full.region), var.region)))}"
  ami = "${element(split(",", data.atlas_artifact.rancher-aws-server.metadata_full.ami_id), index(split(",", data.atlas_artifact.rancher-aws-server.metadata_full.region), var.region))}"

  region = "${var.region}"
  ssh_keypair = "${var.ssh_keypair}"
  zone_id = "${var.zone_id}"
  certificate_id = "${var.certificate_id}"
  cloudfront_certificate_id = "${var.cloudfront_certificate_id}"

  cluster_size = "${var.server_nodes}"
  spot_price = "${var.server_spot_price}"
  spot_allocation = "${var.server_spot_allocation}"
  spot_pools = "${var.server_spot_pools}"
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
  slack_channel = "${var.slack_channel}"
}

data "atlas_artifact" "rancher-aws-staging-host" {
  name = "finboxio/rancher-aws-host"
  type = "amazon.image"
  metadata {
    version = "${coalesce(var.staging_ami_version, var.ami_version)}"
    region = "${var.region}"
  }
}

module "staging" {
  source = "./staging/infrastructure"

  deployment_id = "${module.server.deployment_id}"
  rancher_hostname = "${module.server.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"
  slack_channel = "${var.staging_slack_channel}"
  name = "Staging"
  version = "${coalesce(var.staging_image_version, var.image_version, var.staging_ami_version, var.ami_version, element(split(",", data.atlas_artifact.rancher-aws-staging-host.metadata_full.ami_id), index(split(",", data.atlas_artifact.rancher-aws-staging-host.metadata_full.region), var.region)))}"
  ami = "${element(split(",", data.atlas_artifact.rancher-aws-staging-host.metadata_full.ami_id), index(split(",", data.atlas_artifact.rancher-aws-staging-host.metadata_full.region), var.region))}"

  region = "${var.region}"
  ssh_keypair = "${var.ssh_keypair}"
  zone_id = "${var.zone_id}"
  certificate_id = "${var.staging_certificate_id}"
  cloudfront_certificate_id = "${var.staging_cloudfront_certificate_id}"

  cluster_size = "${var.staging_default_nodes}"
  availability_zones = "${var.staging_default_availability_zones}"
  spot_price = "${var.staging_spot_price}"
  spot_pools = "${var.staging_default_spot_pools}"
  spot_allocation = "${var.staging_default_spot_allocation}"

  shudder_sqs_url = "${module.server.shudder_sqs_url}"
  config_bucket = "${module.server.config_bucket}"
  server_security_group = "${module.server.internal_security_group}"

  mongo_spot_pools = "${var.staging_mongo_spot_pools}"

  analyst_cluster_size = "${var.staging_analyst_nodes}"
  analyst_spot_pools = "${var.staging_analyst_spot_pools}"
}

data "atlas_artifact" "rancher-aws-production-host" {
  name = "finboxio/rancher-aws-host"
  type = "amazon.image"
  metadata {
    version = "${coalesce(var.production_ami_version, var.ami_version)}"
    region = "${var.region}"
  }
}

module "production" {
  source = "./production/infrastructure"

  deployment_id = "${module.server.deployment_id}"
  rancher_hostname = "${module.server.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"
  slack_channel = "${var.production_slack_channel}"
  name = "Production"
  version = "${coalesce(var.production_image_version, var.image_version, var.production_ami_version, var.ami_version)}"
  ami = "${element(split(",", data.atlas_artifact.rancher-aws-production-host.metadata_full.ami_id), index(split(",", data.atlas_artifact.rancher-aws-production-host.metadata_full.region), var.region))}"

  region = "${var.region}"
  ssh_keypair = "${var.ssh_keypair}"
  zone_id = "${var.zone_id}"
  certificate_id = "${var.production_certificate_id}"
  cloudfront_certificate_id = "${var.production_cloudfront_certificate_id}"

  cluster_size = "${var.production_default_nodes}"
  availability_zones = "${var.production_default_availability_zones}"
  spot_price = "${var.production_default_spot_price}"
  spot_pools = "${var.production_default_spot_pools}"
  spot_allocation = "${var.production_default_spot_allocation}"

  shudder_sqs_url = "${module.server.shudder_sqs_url}"
  config_bucket = "${module.server.config_bucket}"
  server_security_group = "${module.server.internal_security_group}"

  mongo1_spot_pools = "${var.production_mongo1_spot_pools}"
  mongo2_spot_pools = "${var.production_mongo2_spot_pools}"

  analyst_cluster_size = "${var.production_analyst_nodes}"
  analyst_spot_pools = "${var.production_analyst_spot_pools}"
}
