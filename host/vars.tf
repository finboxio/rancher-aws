variable "deployment_id" {
  default = "finboxio-default"
}

variable "rancher_url" {
  default = "https://rancher.finbox.io"
}

variable "rancher_access_key_id" {
  default = "2D7EA43C32A1B03145D7"
}

variable "rancher_secret_access_key" {
  default = "QSdYWXLM1HAn8fBWxF63ZvtHHoBJfs23L1UvbL4u"
}

variable "rancher_host_labels" {
  default = "spot_price=.1"
}

variable "cluster_size" {
  default = 1
}

variable "instance_type" {
  default = "m4.large"
}

variable "spot_price" {
  default = 0.05
}

variable "ebs_optimized" {
  default = true
}

variable "ssh_keypair" {
  default = "tino-macbook-pro-keypair"
}

variable "certificate_id" {
  default = "arn:aws:acm:us-west-2:783703853999:certificate/4afe9a81-f0dc-4041-b4a0-9a301bc23550"
}

variable "region" {
  default = "us-west-2"
}
