variable "deployment_id" {}
variable "name" {}
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

variable "sqs_queue" {}
variable "s3_bucket" {}
variable "server_sg" {}

variable "rancher_hostname" {}
variable "rancher_asg_host_version" { default = "" }
variable "slack_webhook" {}
