resource "aws_iam_role" "rancher-fleet-iam-role" {
  name               = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-fleet-iam-role"
  path               = "/"
  assume_role_policy = "${file(format("%s/%s", path.module, "templates/fleet-role.json"))}"
}

resource "aws_iam_policy_attachment" "rancher-fleet-iam-attachment" {
  name       = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-fleet-iam-attachment"
  roles      = [ "${aws_iam_role.rancher-fleet-iam-role.name}" ]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetRole"
}

resource "aws_iam_role" "rancher-spot-iam-role" {
  name               = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-spot-iam-role"
  path               = "/"
  assume_role_policy = "${file(format("%s/%s", path.module, "templates/spot-role.json"))}"
}

data "template_file" "rancher-spot-policy-data" {
  template = "${file(format("%s/%s", path.module, "templates/spot-policy.json"))}"

  vars {
    name          = "rancher"
    deployment_id = "${var.deployment_id}"
    config_bucket     = "${var.config_bucket}"
  }
}

resource "aws_iam_policy" "rancher-spot-iam-policy" {
  name   = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-spot-iam-policy"
  path   = "/"
  policy = "${data.template_file.rancher-spot-policy-data.rendered}"
}

resource "aws_iam_policy_attachment" "rancher-spot-iam-attachment" {
  name       = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-spot-iam-attachment"
  roles      = ["${aws_iam_role.rancher-spot-iam-role.name}"]
  policy_arn = "${aws_iam_policy.rancher-spot-iam-policy.arn}"
}

resource "aws_iam_instance_profile" "rancher-spot-iam-profile" {
  name  = "rancher-${lower(var.deployment_id)}-${lower(var.environment)}-${lower(var.group)}-spot-iam-profile"
  path  = "/"
  roles = ["${aws_iam_role.rancher-spot-iam-role.name}"]
}
