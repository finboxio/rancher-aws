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
variable "server_spot_pools" {}
variable "server_availability_zones" {}

variable "staging_certificate_id" {}
variable "staging_cloudfront_certificate_id" {}
variable "staging_default_nodes" {}
variable "staging_default_availability_zones" {}
variable "staging_default_spot_allocation" {}
variable "staging_default_spot_pools" {}
variable "staging_mongo_spot_pools" {}
variable "staging_analyst_nodes" {}
variable "staging_analyst_spot_pools" {}

variable "production_certificate_id" {}
variable "production_cloudfront_certificate_id" {}
variable "production_default_nodes" {}
variable "production_default_availability_zones" {}
variable "production_default_spot_price" {}
variable "production_default_spot_allocation" {}
variable "production_default_spot_pools" {}
variable "production_mongo1_spot_pools" {}
variable "production_mongo2_spot_pools" {}
variable "production_analyst_nodes" {}
variable "production_analyst_spot_pools" {}
