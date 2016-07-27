resource "aws_autoscaling_group" "rancher-asg" {
  name                 = "${var.deployment_id}-rancher-asg"
  launch_configuration = "${aws_launch_configuration.rancher-lc.name}"
  max_size             = "${var.cluster_size}"
  min_size             = "${(var.cluster_size + 1) / 2}"
  desired_capacity     = "${var.cluster_size}"
  availability_zones   = [ "${split(",", var.availability_zones)}" ]
  load_balancers       = [ "${aws_elb.rancher-elb.id}" ]

  lifecycle {
    create_before_destroy = true
  }

  health_check_type         = "ELB"
  health_check_grace_period = 600

  tag {
    key                 = "Name"
    value               = "${var.deployment_id}-rancher"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_lifecycle_hook" "rancher-hook" {
    name = "${var.deployment_id}-rancher-hook"
    autoscaling_group_name = "${aws_autoscaling_group.rancher-asg.name}"
    default_result = "CONTINUE"
    heartbeat_timeout = 120
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    notification_target_arn = "${aws_sqs_queue.rancher-terminations.arn}"
    role_arn = "${aws_iam_role.rancher-asg-iam-role.arn}"

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_sqs_queue" "rancher-terminations" {
  name = "terminations-${replace(var.rancher_url, ".", "-")}"
  visibility_timeout_seconds = 120

  lifecycle {
    create_before_destroy = true
  }
}
