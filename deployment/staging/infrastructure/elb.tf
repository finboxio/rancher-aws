resource "aws_route53_record" "rancher-dns" {
  zone_id = "${var.zone_id}"
  name    = "staging.finbox.io"
  type    = "A"

  set_identifier = "finboxio-staging-dns"
  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = "${aws_elb.rancher-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "rancher-wildcard-dns" {
  zone_id = "${var.zone_id}"
  name    = "*.staging.finbox.io"
  type    = "A"

  set_identifier = "finboxio-staging-wildcard-dns"
  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = "${aws_elb.rancher-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_security_group" "rancher-host-sg" {
  name = "rancher-finboxio-staging-host-sg"
  description = "Allow traffic to ports used by rancher hosts"

  ingress {
    from_port = 79
    to_port = 79
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_elb" "rancher-elb" {
  name               = "rancher-finboxio-staging-elb"
  availability_zones = [ "${split(",", var.availability_zones)}" ]

  security_groups = [
    "${var.server_security_group}",
    "${aws_security_group.rancher-host-sg.id}"
  ]

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "tcp"
    lb_port            = 443
    lb_protocol        = "ssl"
    ssl_certificate_id = "${var.certificate_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:79/live-router"
    interval            = 30
  }

  idle_timeout                = 120
  connection_draining         = true
  connection_draining_timeout = 120
  cross_zone_load_balancing   = true

  tags {
    Name = "rancher-finboxio-staging-elb"
  }
}

resource "aws_proxy_protocol_policy" "proxy-protocol" {
  load_balancer = "${aws_elb.rancher-elb.name}"
  instance_ports = [ "80" ]
}
