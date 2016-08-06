resource "aws_spot_fleet_request" "rancher-fleet" {
  iam_fleet_role = "${aws_iam_role.rancher-fleet-iam-role.arn}"

  spot_price = 0.10
  target_capacity = 0
  allocation_strategy = "lowestPrice"
  valid_until = "2020-01-01T00:00:00Z"
  terminate_instances_with_expiration = true

  launch_specification {
    instance_type = "c3.large"
    availability_zone = "us-west-2a"
    iam_instance_profile = "${aws_iam_instance_profile.rancher-spot-iam-profile.id}"
    ami = "ami-f0f03190"
    ebs_optimized = "false"
    key_name = "tino-macbook-pro-keypair"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${aws_security_group.rancher-fleet-internal-sg.id}",
      "${aws_security_group.rancher-fleet-external-sg.id}"
    ]
  }
}
