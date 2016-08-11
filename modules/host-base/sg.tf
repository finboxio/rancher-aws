resource "aws_security_group" "rancher-sg" {
  name = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-sg"
  description = "Allow traffic to ports used by rancher hosts"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 2490
    to_port = 2490
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ "${var.server_security_group}" ]
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
