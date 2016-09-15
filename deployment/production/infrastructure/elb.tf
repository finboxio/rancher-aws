resource "aws_route53_record" "rancher-dns" {
  zone_id = "${var.zone_id}"
  name    = "production.finbox.io"
  type    = "A"

  set_identifier = "finboxio-production-dns"
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
  name    = "*.production.finbox.io"
  type    = "A"

  set_identifier = "finboxio-production-wildcard-dns"
  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = "${aws_elb.rancher-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "rancher-root-dns" {
  zone_id = "${var.zone_id}"
  name    = "finbox.io"
  type    = "A"

  set_identifier = "finboxio-production-dns"
  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = "${aws_elb.rancher-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "rancher-root-wildcard-dns" {
  zone_id = "${var.zone_id}"
  name    = "*.finbox.io"
  type    = "A"

  set_identifier = "finboxio-production-wildcard-dns"
  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = "${aws_elb.rancher-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "rancher-elb" {
  name               = "rancher-finboxio-production-elb"
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
    Name = "rancher-finboxio-production-elb"
  }
}

resource "aws_proxy_protocol_policy" "proxy-protocol" {
  load_balancer = "${aws_elb.rancher-elb.name}"
  instance_ports = [ "80" ]
}
