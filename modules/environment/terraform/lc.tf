resource "atlas_artifact" "rancher-asg-host" {
  name = "finboxio/rancher-asg-host"
  type = "amazon.image"
  version = "${var.rancher_asg_host_version}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "rancher-userdata-template" {
  template = "${file(concat(path.module, "/templates/cloud-config.yml"))}"

  vars {
    rancher_hostname       = "${var.rancher_hostname}"
    s3_bucket              = "${var.s3_bucket}"
    environment_name       = "${var.name}"
    environment_type       = "${var.type}"
    slack_webhook          = "${var.slack_webhook}"
    version                = "${atlas_artifact.rancher-asg-host.metadata_full.version}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "rancher-lc" {
  image_id             = "${element(split(",", atlas_artifact.rancher-asg-host.metadata_full.ami_id), index(split(",", atlas_artifact.rancher-asg-host.metadata_full.region), var.region))}"
  name_prefix          = "${var.deployment_id}-rancher-${var.name}-"
  instance_type        = "${var.instance_type}"
  spot_price           = "${var.spot_price}"
  key_name             = "${var.ssh_keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.rancher-ec2-iam-profile.id}"

  security_groups = [
    "${aws_security_group.rancher-sg.id}",
    "${var.server_sg}"
  ]

  ebs_optimized     = "${var.ebs_optimized}"
  enable_monitoring = false
  user_data         = "${template_file.rancher-userdata-template.rendered}"

  root_block_device = {
    volume_size = 16
  }

  lifecycle {
    create_before_destroy = true
  }
}
