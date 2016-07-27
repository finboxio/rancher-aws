resource "aws_security_group" "rancher-sg" {
  name = "${var.deployment_id}-host-sg"
  description = "Allow traffic to ports used by rancher hosts"

  ingress {
    from_port = 22
    to_port = 22
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

  ingress {
    from_port = 500
    to_port = 500
    protocol = "UDP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 4500
    to_port = 4500
    protocol = "UDP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ "${aws_security_group.rancher-internal-sg.id}" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "rancher-internal-sg" {
  name = "${var.deployment_id}-host-internal-sg"
  description = "Allow traffic to ports used by rancher"

  lifecycle {
    create_before_destroy = true
  }
}
