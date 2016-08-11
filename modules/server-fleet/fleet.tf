resource "aws_spot_fleet_request" "rancher-fleet" {
  iam_fleet_role = "${aws_iam_role.rancher-fleet-iam-role.arn}"

  spot_price = "${var.spot_price}"
  target_capacity = "${var.cluster_size}"
  allocation_strategy = "${var.spot_allocation}"
  valid_until = "2020-01-01T00:00:00Z"
  terminate_instances_with_expiration = false

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 0)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 0)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 0)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 0)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 1)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 1)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 1)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 1)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 2)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 2)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 2)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 2)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 3)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 3)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 3)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 3)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 4)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 4)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 4)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 4)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 5)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 5)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 5)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 5)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 6)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 6)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 6)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 6)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 7)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 7)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 7)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 7)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 8)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 8)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 8)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 8)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 9)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 9)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 9)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 9)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 10)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 10)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 10)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 10)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 11)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 11)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 11)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 11)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 12)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 12)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 12)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 12)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 13)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 13)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 13)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 13)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 14)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 14)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 14)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 14)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }

  launch_specification {
    instance_type = "${element(split(":", element(split(",", var.spot_pools), 15)), 0)}"
    availability_zone = "${element(split(":", element(split(",", var.spot_pools), 15)), 1)}"
    weighted_capacity = "${coalesce(element(split(":", element(split(",", var.spot_pools), 15)), 2), 1)}"
    spot_price = "${coalesce(element(split(":", element(split(",", var.spot_pools), 15)), 3), var.spot_price)}"
    ami = "${var.ami}"
    user_data = "${module.base.user_data}"
    iam_instance_profile = "${module.base.instance_profile}"
    key_name = "${var.ssh_keypair}"
    monitoring = false
    vpc_security_group_ids = [
      "${module.base.external_security_group}",
      "${module.base.internal_security_group}"
    ]
  }
}
