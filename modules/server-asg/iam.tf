resource "aws_iam_role" "rancher-ec2-iam-role" {
  name               = "rancher-${lower(var.deployment_id)}-ec2-iam-role"
  path               = "/"
  assume_role_policy = "${file(format("%s/%s", path.module, "templates/ec2-role.json"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "rancher-ec2-iam-profile" {
  name  = "rancher-${lower(var.deployment_id)}-ec2-iam-profile"
  path  = "/"
  roles = ["${aws_iam_role.rancher-ec2-iam-role.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "rancher-ec2-policy-data" {
  template = "${file(format("%s/%s", path.module, "templates/ec2-policy.json"))}"

  vars {
    name          = "rancher"
    s3_bucket     = "${aws_s3_bucket.rancher-bucket.bucket}"
  }
}

resource "aws_iam_policy" "rancher-ec2-iam-policy" {
  name   = "rancher-${lower(var.deployment_id)}-ec2-iam-policy"
  path   = "/"
  policy = "${data.template_file.rancher-ec2-policy-data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "rancher-ec2-iam-attachment" {
  name       = "rancher-${lower(var.deployment_id)}-ec2-iam-attachment"
  roles      = ["${aws_iam_role.rancher-ec2-iam-role.name}"]
  policy_arn = "${aws_iam_policy.rancher-ec2-iam-policy.arn}"

  lifecycle {
    create_before_destroy = true
  }
}
