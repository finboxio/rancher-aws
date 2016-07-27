resource "aws_elb" "rancher-elb" {
  name = "${var.deployment_id}-host-elb"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  security_groups = [
    "${aws_security_group.rancher-sg.id}",
    "${aws_security_group.rancher-internal-sg.id}"
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

  idle_timeout = 120
  connection_draining = true
  connection_draining_timeout = 120
  cross_zone_load_balancing = true

  tags {
    Name = "${var.deployment_id}-host-elb"
  }
}
