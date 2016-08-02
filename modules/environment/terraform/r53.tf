resource "aws_route53_record" "rancher-environment-dns" {
  zone_id = "${var.zone_id}"
  name    = "${var.name}.${var.rancher_hostname}"
  type    = "A"

  alias {
    name                   = "${aws_elb.rancher-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-elb.zone_id}"
    evaluate_target_health = true
  }
}
