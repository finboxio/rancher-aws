variable "deployment_id" {}
variable "environment" {}
variable "group" {}
variable "type" { default = "cattle" }

variable "region" {}
variable "availability_zones" {}
variable "instance_type" {}
variable "spot_price" {}
variable "ebs_optimized" { default = false }
variable "cluster_size" { default = 2 }
variable "ssh_keypair" {}
variable "zone_id" {}
variable "certificate_id" {}

variable "shudder_sqs_url" {}
variable "config_bucket" {}
variable "server_sg" {}

variable "ami" {}
variable "version" {}
variable "rancher_hostname" {}
variable "slack_webhook" {}
