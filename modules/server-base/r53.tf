resource "aws_route53_record" "rancher-dns" {
  zone_id = "${var.zone_id}"
  name    = "${var.rancher_hostname}"
  type    = "A"

  alias {
    name                   = "${aws_elb.rancher-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "rancher-wildcard-dns" {
  zone_id = "${var.zone_id}"
  name    = "*.${var.rancher_hostname}"
  type    = "A"

  alias {
    name                   = "${aws_elb.rancher-elb.dns_name}"
    zone_id                = "${aws_elb.rancher-elb.zone_id}"
    evaluate_target_health = true
  }
}
