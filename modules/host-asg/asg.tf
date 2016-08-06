resource "aws_autoscaling_group" "rancher-asg" {
  name                 = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-asg"
  launch_configuration = "${aws_launch_configuration.rancher-lc.name}"
  max_size             = "${var.cluster_size}"
  min_size             = "${var.cluster_size}"
  desired_capacity     = "${var.cluster_size}"
  availability_zones   = [ "${split(",", var.availability_zones)}" ]
  load_balancers       = [ "${aws_elb.rancher-elb.id}" ]

  lifecycle {
    create_before_destroy = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}"
    propagate_at_launch = true
  }
}
