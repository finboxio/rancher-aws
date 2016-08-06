resource "aws_elb" "rancher-elb" {
  name = "${format("rancher-%.6s-%.6s-%.6s-elb", lower(var.deployment_id), lower(var.environment), lower(var.group))}"
  availability_zones = [ "${split(",", var.availability_zones)}" ]

  security_groups = [
    "${aws_security_group.rancher-sg.id}",
    "${var.server_sg}"
  ]

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "ssl"
    ssl_certificate_id = "${var.certificate_id}"
  }

  listener {
    instance_port = 2490
    instance_protocol = "tcp"
    lb_port = 2490
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    target              = "HTTP:2490/"
    interval            = 30
  }

  idle_timeout = 120
  connection_draining = true
  connection_draining_timeout = 120
  cross_zone_load_balancing = true

  tags {
    Name = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-elb"
  }

  lifecycle {
    create_before_destroy = true
  }
}
