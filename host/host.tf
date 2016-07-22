resource "template_file" "rancher-userdata-template" {
  template = "${file("templates/cloud-config.yml")}"
  vars {
    rancher_s3_bucket = "${aws_s3_bucket.rancher-bucket.bucket}"
    region = "${var.region}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "rancher-lc" {
  image_id = "ami-f0f03190"
  name_prefix = "${var.deployment_id}-host-"
  instance_type = "${var.instance_type}"
  spot_price = "${var.spot_price}"
  key_name = "${var.ssh_keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.rancher-iam-profile.id}"
  security_groups = [
    "${aws_security_group.rancher-sg.id}",
    "${aws_security_group.rancher-internal-sg.id}"
  ]
  ebs_optimized = "${var.ebs_optimized}"
  enable_monitoring = false
  user_data = "${template_file.rancher-userdata-template.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rancher-asg" {
  name = "${var.deployment_id}-host-asg"
  launch_configuration = "${aws_launch_configuration.rancher-lc.name}"
  max_size = "${var.cluster_size}"
  min_size = "${var.cluster_size}"
  desired_capacity = "${var.cluster_size}"
  availability_zones = [ "us-west-2a", "us-west-2b", "us-west-2c" ]
  load_balancers = [ "${aws_elb.rancher-elb.id}" ]

  health_check_type = "EC2"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.deployment_id}-host-asg"
    propagate_at_launch = true
  }
}
