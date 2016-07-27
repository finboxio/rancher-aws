resource "aws_iam_role" "rancher-iam-role" {
  name = "${var.deployment_id}-host-iam-role"
  path = "/"
  assume_role_policy = "${file("templates/role.json")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "rancher-iam-profile" {
  name  = "${var.deployment_id}-host-iam-profile"
  path  = "/"
  roles = [ "${aws_iam_role.rancher-iam-role.name}" ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "rancher-policy-data" {
  template = "${file("templates/policy.json")}"
  vars {
    name = "rancher"
    deployment_id = "${var.deployment_id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "rancher-iam-policy" {
  name   = "${var.deployment_id}-host-iam-policy"
  path   = "/"
  policy = "${template_file.rancher-policy-data.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "rancher-iam-attachment" {
  name = "${var.deployment_id}-host-iam-attachment"
  roles = [ "${aws_iam_role.rancher-iam-role.name}" ]
  policy_arn = "${aws_iam_policy.rancher-iam-policy.arn}"
  lifecycle {
    create_before_destroy = true
  }
}
