resource "aws_launch_configuration" "rancher-lc" {
  image_id             = "${var.ami}"
  name_prefix          = "rancher-${lower(var.deployment_id)}-"
  instance_type        = "${var.instance_type}"
  spot_price           = "${var.spot_price}"
  key_name             = "${var.ssh_keypair}"
  iam_instance_profile = "${module.base.instance_profile}"

  security_groups = [
    "${module.base.external_security_group}",
    "${module.base.internal_security_group}"
  ]

  user_data         = "${module.base.user_data}"
  ebs_optimized     = "${var.ebs_optimized}"
  enable_monitoring = false

  root_block_device = {
    volume_size = 16
  }

  lifecycle {
    create_before_destroy = true
  }
}
