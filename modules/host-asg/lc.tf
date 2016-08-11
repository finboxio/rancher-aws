resource "aws_launch_configuration" "rancher-lc" {
  image_id             = "${var.ami}"
  name_prefix          = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-"
  instance_type        = "${var.instance_type}"
  spot_price           = "${var.spot_price}"
  key_name             = "${var.ssh_keypair}"
  iam_instance_profile = "${module.hosts.instance_profile}"

  security_groups = [
    "${module.hosts.external_security_group}",
    "${var.host_security_group}",
    "${var.server_security_group}"
  ]

  ebs_optimized     = "${var.ebs_optimized}"
  enable_monitoring = false
  user_data         = "${module.hosts.user_data}"

  root_block_device = {
    volume_size = 16
  }

  lifecycle {
    create_before_destroy = true
  }
}
