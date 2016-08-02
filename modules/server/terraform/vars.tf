variable "deployment_id" {}

variable "region" {}
variable "availability_zones" {}
variable "instance_type" {}
variable "spot_price" {}
variable "ebs_optimized" { default = false }
variable "cluster_size" { default = 2 }
variable "ssh_keypair" {}
variable "zone_id" {}
variable "certificate_id" {}

variable "rancher_hostname" {}
variable "rancher_asg_server_version" { default = "" }
variable "mysql_root_password" {}
variable "mysql_volume_size" {}
variable "rancher_mysql_user" {}
variable "rancher_mysql_password" {}
variable "rancher_mysql_database" {}
variable "rancher_admin_user" {}
variable "rancher_admin_password" {}
variable "slack_webhook" {}