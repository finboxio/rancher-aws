variable "name" {}

variable "deployment_id" {}
variable "shudder_sqs_url" {}
variable "config_bucket" {}
variable "server_security_group" {}
variable "rancher_hostname" {}

variable "ssh_keypair" {}
variable "zone_id" {}
variable "certificate_id" {}
variable "cloudfront_certificate_id" {}

variable "region" {}
variable "availability_zones" {}
variable "cluster_size" {}
variable "spot_pools" {}
variable "spot_price" {}
variable "spot_allocation" {}

variable "slack_webhook" {}
variable "slack_channel" {}

variable "ami" {}
variable "version" { default = "" }

variable "mongo_spot_pools" {}

variable "analyst_cluster_size" {}
variable "analyst_spot_pools" {}

output "version" { value = "${var.version}" }
