resource "aws_security_group" "rancher-staging-mongo-sg" {
  name = "rancher-finboxio-staging-mongo-host-sg"
  description = "Allow traffic to ports used by rancher hosts"

  ingress {
    from_port = 32810
    to_port = 32810
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "rancher-mongo-elb" {
  name               = "rancher-finboxio-stag-mong-elb"
  availability_zones = [ "${split(",", var.availability_zones)}" ]

  security_groups = [
    "${var.server_security_group}",
    "${aws_security_group.rancher-staging-mongo-sg.id}"
  ]

  listener {
    instance_port      = 32810
    instance_protocol  = "tcp"
    lb_port            = 32810
    lb_protocol        = "ssl"
    ssl_certificate_id = "${var.certificate_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:32810"
    interval            = 30
  }

  idle_timeout                = 120
  connection_draining         = true
  connection_draining_timeout = 120
  cross_zone_load_balancing   = true

  tags {
    Name = "rancher-finboxio-stag-mong-elb"
  }
}

resource "aws_route53_record" "rancher-mongo-dns" {
  zone_id = "${var.zone_id}"
  name    = "mongo.staging.finbox.io"
  type    = "A"

  alias {
    name                   = "${aws_elb.rancher-mongo-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-mongo-elb.zone_id}"
    evaluate_target_health = false
  }
}

module "mongo" {
  source = "../../../modules/host-fleet"
  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "mongo"
  type = "cattle"

  spot_pools = "${var.mongo_spot_pools}"

  cluster_size = "1"
  spot_allocation = "diversified"
  spot_price = "${var.spot_price}"
  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  elb_name = "${aws_elb.rancher-mongo-elb.name}"
  host_security_group = "${aws_security_group.rancher-staging-mongo-sg.id}"
  server_security_group = "${var.server_security_group}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"

  version = "${var.version}"
  ami = "${var.ami}"
}
