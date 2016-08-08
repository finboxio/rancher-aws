resource "aws_iam_role" "rancher-fleet-iam-role" {
  name               = "rancher-${lower(var.deployment_id)}-fleet-iam-role"
  path               = "/"
  assume_role_policy = "${file(format("%s/%s", path.module, "templates/fleet-role.json"))}"
}

resource "aws_iam_policy_attachment" "rancher-fleet-iam-attachment" {
  name       = "rancher-${lower(var.deployment_id)}-fleet-iam-attachment"
  roles      = [ "${aws_iam_role.rancher-fleet-iam-role.name}" ]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetRole"
}
