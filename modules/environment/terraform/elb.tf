resource "aws_elb" "rancher-elb" {
  name = "${var.deployment_id}-rancher-${var.name}-elb"
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

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:9200/"
    interval            = 30
  }

  idle_timeout = 120
  connection_draining = true
  connection_draining_timeout = 120
  cross_zone_load_balancing = true

  tags {
    Name = "${var.deployment_id}-rancher-${var.name}-elb"
  }

  lifecycle {
    create_before_destroy = true
  }
}
