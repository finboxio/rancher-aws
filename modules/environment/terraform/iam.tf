resource "aws_iam_role" "rancher-ec2-iam-role" {
  name               = "${var.deployment_id}-rancher-${var.name}-ec2-iam-role"
  path               = "/"
  assume_role_policy = "${file(concat(path.module, "/templates/ec2-role.json"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "rancher-ec2-iam-profile" {
  name  = "${var.deployment_id}-rancher-${var.name}-ec2-iam-profile"
  path  = "/"
  roles = [ "${aws_iam_role.rancher-ec2-iam-role.name}" ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "rancher-ec2-policy-data" {
  template = "${file(concat(path.module, "/templates/ec2-policy.json"))}"

  vars {
    name          = "rancher"
    deployment_id = "${var.deployment_id}"
    s3_bucket     = "${var.s3_bucket}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "rancher-ec2-iam-policy" {
  name   = "${var.deployment_id}-rancher-${var.name}-ec2-iam-policy"
  path   = "/"
  policy = "${template_file.rancher-ec2-policy-data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "rancher-ec2-iam-attachment" {
  name       = "${var.deployment_id}-rancher-${var.name}-ec2-iam-attachment"
  roles      = [ "${aws_iam_role.rancher-ec2-iam-role.name}" ]
  policy_arn = "${aws_iam_policy.rancher-ec2-iam-policy.arn}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "rancher-asg-iam-role" {
  name               = "${var.deployment_id}-rancher-${var.name}-asg-iam-role"
  path               = "/"
  assume_role_policy = "${file(concat(path.module, "/templates/asg-role.json"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "rancher-asg-policy-data" {
  template = "${file(concat(path.module, "/templates/asg-policy.json"))}"

  vars {
    sqs_arn = "${var.sqs_queue}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "rancher-asg-iam-policy" {
  name   = "${var.deployment_id}-rancher-${var.name}-asg-iam-policy"
  path   = "/"
  policy = "${template_file.rancher-asg-policy-data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "rancher-asg-iam-attachment" {
  name       = "${var.deployment_id}-rancher-${var.name}-asg-iam-attachment"
  roles      = [ "${aws_iam_role.rancher-asg-iam-role.name}" ]
  policy_arn = "${aws_iam_policy.rancher-asg-iam-policy.arn}"

  lifecycle {
    create_before_destroy = true
  }
}
