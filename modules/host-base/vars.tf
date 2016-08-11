variable "deployment_id" {}
variable "rancher_hostname" {}
variable "environment" {}
variable "group" {}
variable "type" { default = "cattle" }

variable "shudder_sqs_url" {}
variable "config_bucket" {}
variable "server_security_group" {}
variable "elb_name" { default = "" }

variable "slack_webhook" {}
variable "version" {}
