resource "aws_elb" "rancher-elb" {
  name               = "${var.deployment_id}-rancher-elb"
  availability_zones = [ "${split(",", var.availability_zones)}" ]

  security_groups = [
    "${aws_security_group.rancher-sg.id}",
    "${aws_security_group.rancher-internal-sg.id}",
  ]

  listener {
    instance_port     = 8881
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 18080
    instance_protocol = "tcp"
    lb_port           = 18080
    lb_protocol       = "tcp"
  }

  listener {
    instance_port      = 8881
    instance_protocol  = "tcp"
    lb_port            = 443
    lb_protocol        = "ssl"
    ssl_certificate_id = "${var.certificate_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8880/rancher-health"
    interval            = 30
  }

  idle_timeout                = 120
  connection_draining         = true
  connection_draining_timeout = 120
  cross_zone_load_balancing   = true

  tags {
    Name = "${var.deployment_id}-rancher-elb"
  }
}

resource "aws_proxy_protocol_policy" "proxy-protocol" {
  load_balancer = "${aws_elb.rancher-elb.name}"
  instance_ports = [ "8881" ]

  lifecycle {
    create_before_destroy = true
  }
}
