resource "aws_security_group" "rancher-fleet-internal-sg" {
  name        = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-internal-sg"
  description = "Allow traffic to ports used by rancher"
}

resource "aws_security_group" "rancher-fleet-external-sg" {
  name = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-sg"
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
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ "${aws_security_group.rancher-fleet-internal-sg.id}" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
