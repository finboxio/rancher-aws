variable "deployment_id" {}
variable "rancher_hostname" {}
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

variable "shudder_sqs_url" {}
variable "config_bucket" {}
variable "server_security_group" {}
variable "host_security_group" { default = "" }

variable "ami" {}
variable "version" {}
variable "slack_webhook" {}
