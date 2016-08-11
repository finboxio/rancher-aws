variable "test" { default = "ah" }

variable "deployment_id" { default = "finboxio" }
variable "rancher_hostname" {}
variable "environment" { default = "Staging" }
variable "group" { default = "mongo" }
variable "type" { default = "cattle" }

variable "cluster_size" {}
variable "spot_pools" {}
variable "spot_price" {}
variable "spot_allocation" {}

variable "ami" {}
variable "ssh_keypair" {}
variable "config_bucket" { default = "finboxio-rancher-config" }

variable "shudder_sqs_url" {}
variable "config_bucket" {}
variable "server_security_group" {}
variable "host_security_group" {}
variable "elb_name" { default = "" }

variable "slack_webhook" {}
variable "version" {}
