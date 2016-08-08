variable "name" {}

variable "deployment_id" {}
variable "shudder_sqs_url" {}
variable "config_bucket" {}
variable "server_sg" {}
variable "rancher_hostname" {}

variable "ssh_keypair" {}
variable "zone_id" {}
variable "certificate_id" {}

variable "region" {}
variable "availability_zones" {}
variable "cluster_size" {}
variable "instance_type" {}
variable "spot_price" {}

variable "slack_webhook" {}

variable "ami" {}
variable "version" { default = "" }
