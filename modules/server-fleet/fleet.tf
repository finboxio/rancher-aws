resource "aws_spot_fleet_request" "rancher-fleet" {
  iam_fleet_role = "${aws_iam_role.rancher-fleet-iam-role.arn}"

  spot_price = "${var.spot_price}"
  target_capacity = "${var.cluster_size}"
  allocation_strategy = "${var.spot_allocation}"
  valid_until = "2020-01-01T00:00:00Z"
  terminate_instances_with_expiration = false

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 0 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 0 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 1 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 1 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 2 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 2 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 3 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 3 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 4 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 4 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 5 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 5 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 6 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 6 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 7 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 7 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 8 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 8 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 9 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 9 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 10 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 10 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 11 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 11 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 12 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 12 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 13 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 13 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 14 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 14 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(",", var.instance_types), 15 / length(split(",",var.availability_zones)))}"
    availability_zone = "${element(split(",", var.availability_zones), 15 % length(split(",",var.availability_zones)))}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    ebs_optimized = "${var.ebs_optimized}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    weighted_capacity = 1
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }
}
