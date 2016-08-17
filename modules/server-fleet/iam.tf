resource "aws_iam_role" "rancher-fleet-iam-role" {
  name               = "rancher-${lower(var.deployment_id)}-fleet-iam-role"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "spotfleet.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "rancher-fleet-iam-policy" {
    name = "rancher-${lower(var.deployment_id)}-fleet-iam-policy"
    path = "/"
    description = "Rancher fleet iam policy"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "ec2:DescribeImages",
      "ec2:DescribeSubnets",
      "ec2:RequestSpotInstances",
      "ec2:TerminateInstances",
      "iam:PassRole"
    ],
    "Resource": ["*"]
  }]
}
EOF
}

resource "aws_iam_policy_attachment" "rancher-fleet-iam-attachment" {
  name       = "rancher-${lower(var.deployment_id)}-fleet-iam-attachment"
  roles      = [ "${aws_iam_role.rancher-fleet-iam-role.name}" ]
  policy_arn = "${aws_iam_policy.rancher-fleet-iam-policy.arn}"
}
