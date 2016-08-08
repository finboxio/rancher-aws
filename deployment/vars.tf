variable "deployment_id" {}
variable "version" { default = "" }
variable "use_latest" { default = "" }

variable "region" {}
variable "ssh_keypair" {}
variable "zone_id" {}
variable "certificate_id" {}
variable "cloudfront_certificate_id" {}

variable "rancher_hostname" {}
variable "mysql_root_password" {}
variable "mysql_volume_size" {}
variable "rancher_mysql_user" {}
variable "rancher_mysql_password" {}
variable "rancher_mysql_database" {}
variable "rancher_admin_user" {}
variable "rancher_admin_password" {}
variable "slack_webhook" {}

variable "server_nodes" {}
variable "server_spot_price" {}
variable "server_spot_allocation" {}
variable "server_instance_types" {}
variable "server_availability_zones" {}

variable "staging_default_nodes" {}
variable "staging_default_availability_zones" {}
variable "staging_default_instance_type" {}
