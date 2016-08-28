variable "deployment_id" {}

variable "region" {}
variable "availability_zones" {}
variable "cluster_size" { default = 2 }
variable "zone_id" {}
variable "certificate_id" {}
variable "cloudfront_certificate_id" {}

variable "version" {}
variable "rancher_hostname" {}
variable "rancher_server" { default = "rancher/server:latest" }
variable "rancher_agent" { default = "" }
variable "mysql_root_password" {}
variable "mysql_volume_size" {}
variable "rancher_mysql_user" {}
variable "rancher_mysql_password" {}
variable "rancher_mysql_database" {}
variable "rancher_admin_user" {}
variable "rancher_admin_password" {}
variable "slack_webhook" {}
