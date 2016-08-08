resource "aws_iam_user" "rancher-status-user" {
  name = "rancher-${lower(var.deployment_id)}-status"
}

resource "aws_iam_user_policy" "rancher-status-user-policy" {
  name = "rancher-${lower(var.deployment_id)}-status-policy"
  user = "${aws_iam_user.rancher-status-user.name}"
  policy= <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.rancher-status-bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.rancher-status-bucket.bucket}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_access_key" "rancher-status-user-access-key" {
  user = "${aws_iam_user.rancher-status-user.name}"
}

resource "aws_s3_bucket" "rancher-status-bucket" {
  bucket = "status.${var.rancher_hostname}"
  force_destroy = true
  acl = "public-read"

  website {
    index_document = "index.html"
  }

  cors_rule {
    allowed_origins = [ "*" ]
    allowed_methods = [ "GET", "HEAD" ]
    expose_headers = [ "ETag" ]
    allowed_headers = [ "*" ]
    max_age_seconds = 3000
  }

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::status.${var.rancher_hostname}/*"
  }]
}
POLICY
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "index.html"
  content_type = "text/html"
  source = "${format("%s/%s", path.module, "status/index.html")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/index.html")))}"
}

data "template_file" "rancher-status-config" {
  template = "${file(format("%s/%s", path.module, "status/js/config.js"))}"

  vars {
    bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
    region = "${var.region}"
    access_key_id = "${aws_iam_access_key.rancher-status-user-access-key.id}"
    secret_access_key = "${aws_iam_access_key.rancher-status-user-access-key.secret}"
  }
}

resource "aws_s3_bucket_object" "css" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "css/style.css"
  content_type = "text/css"
  source = "${format("%s/%s", path.module, "status/css/style.css")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/css/style.css")))}"
}

resource "aws_s3_bucket_object" "js-checkup" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "js/checkup.js"
  content_type = "application/javascript"
  source = "${format("%s/%s", path.module, "status/js/checkup.js")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/js/checkup.js")))}"
}

resource "aws_s3_bucket_object" "js-config" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "js/config.js"
  content_type = "application/javascript"
  content = "${data.template_file.rancher-status-config.rendered}"
  etag = "${md5(data.template_file.rancher-status-config.rendered)}"
}

resource "aws_s3_bucket_object" "js-d3" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "js/d3.v3.min.js"
  content_type = "application/javascript"
  source = "${format("%s/%s", path.module, "status/js/d3.v3.min.js")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/js/d3.v3.min.js")))}"
}

resource "aws_s3_bucket_object" "js-s3" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "js/s3.js"
  content_type = "application/javascript"
  source = "${format("%s/%s", path.module, "status/js/s3.js")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/js/s3.js")))}"
}

resource "aws_s3_bucket_object" "js-s3-sdk" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "js/s3.v2.4.13.min.js"
  content_type = "application/javascript"
  source = "${format("%s/%s", path.module, "status/js/s3.v2.4.13.min.js")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/js/s3.v2.4.13.min.js")))}"
}

resource "aws_s3_bucket_object" "js-statuspage" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "js/statuspage.js"
  content_type = "application/javascript"
  source = "${format("%s/%s", path.module, "status/js/statuspage.js")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/js/statuspage.js")))}"
}

resource "aws_s3_bucket_object" "images-checkup" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/checkup.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/checkup.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/checkup.png")))}"
}

resource "aws_s3_bucket_object" "images-degraded" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/degraded.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/degraded.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/degraded.png")))}"
}

resource "aws_s3_bucket_object" "images-favicon" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/favicon.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/favicon.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/favicon.png")))}"
}

resource "aws_s3_bucket_object" "images-incident" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/incident.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/incident.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/incident.png")))}"
}

resource "aws_s3_bucket_object" "images-ok" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/ok.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/ok.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/ok.png")))}"
}

resource "aws_s3_bucket_object" "images-status-gray" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/status-gray.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/status-gray.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/status-gray.png")))}"
}

resource "aws_s3_bucket_object" "images-status-green" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/status-green.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/status-green.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/status-green.png")))}"
}

resource "aws_s3_bucket_object" "images-status-red" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/status-red.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/status-red.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/status-red.png")))}"
}

resource "aws_s3_bucket_object" "images-status-yellow" {
  bucket = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  key = "images/status-yellow.png"
  content_type = "image/png"
  source = "${format("%s/%s", path.module, "status/images/status-yellow.png")}"
  etag = "${md5(file(format("%s/%s", path.module, "status/images/status-yellow.png")))}"
}

resource "aws_cloudfront_distribution" "rancher-status-distribution" {
  origin {
    domain_name = "${aws_s3_bucket.rancher-status-bucket.bucket}.s3.amazonaws.com"
    origin_id   = "rancher-status-origin"
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = [ "status.rancher.finbox.io" ]

  default_cache_behavior {
    allowed_methods  = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods   = [ "GET", "HEAD" ]
    target_origin_id = "rancher-status-origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.cloudfront_certificate_id}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }
}

resource "aws_route53_record" "rancher-status-cf-dns" {
  zone_id = "${var.zone_id}"
  name = "${aws_s3_bucket.rancher-status-bucket.bucket}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.rancher-status-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-status-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
