resource "aws_s3_bucket" "rancher-production-maintenance-bucket" {
  bucket = "maintenance.production.finbox.io"
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
    "Resource": "arn:aws:s3:::maintenance.production.finbox.io/*"
  }]
}
POLICY
}

resource "aws_cloudfront_distribution" "rancher-production-maintenance-distribution" {
  origin {
    domain_name = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}.s3.amazonaws.com"
    origin_id   = "finboxio-production-maintenance-origin"
  }

  enabled = true
  comment = "Maintenance page for production.finbox.io"
  default_root_object = "no.file"

  aliases = [ "finbox.io", "*.finbox.io", "*.production.finbox.io" ]

  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "finboxio-production-maintenance-origin"
    compress = true

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
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

  custom_error_response {
    error_caching_min_ttl = 3600
    error_code = 403
    response_code = 503
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 3600
    error_code = 404
    response_code = 503
    response_page_path = "/index.html"
  }
}

resource "aws_cloudfront_distribution" "rancher-production-404-distribution" {
  origin {
    domain_name = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}.s3.amazonaws.com"
    origin_id   = "finboxio-production-404-origin"
  }

  enabled = true
  comment = "404 page for production.finbox.io"
  default_root_object = "no.file"

  aliases = [ "null.finbox.io", "null.production.finbox.io" ]

  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "finboxio-production-404-origin"
    compress = true

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
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

  custom_error_response {
    error_caching_min_ttl = 3600
    error_code = 403
    response_code = 404
    response_page_path = "/404.html"
  }

  custom_error_response {
    error_caching_min_ttl = 3600
    error_code = 404
    response_code = 404
    response_page_path = "/404.html"
  }
}

resource "aws_route53_record" "rancher-production-maintenance-dns" {
  zone_id = "${var.zone_id}"
  name = "maintenance.production.finbox.io"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "rancher-production-404-dns" {
  zone_id = "${var.zone_id}"
  name = "null.production.finbox.io"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.rancher-production-404-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-production-404-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "rancher-maintenance-dns" {
  zone_id = "${var.zone_id}"
  name = "maintenance.finbox.io"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "rancher-404-dns" {
  zone_id = "${var.zone_id}"
  name = "null.finbox.io"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.rancher-production-404-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-production-404-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "rancher-production-failover-dns" {
  zone_id = "${var.zone_id}"
  name    = "production.finbox.io"
  type    = "A"

  set_identifier = "secondary-finboxio-production-dns"
  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "rancher-production-failover-wildcard-dns" {
  zone_id = "${var.zone_id}"
  name    = "*.production.finbox.io"
  type    = "A"

  set_identifier = "secondary-finboxio-production-wildcard-dns"
  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "rancher-production-failover-root-dns" {
  zone_id = "${var.zone_id}"
  name    = "finbox.io"
  type    = "A"

  set_identifier = "secondary-finboxio-production-root-dns"
  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "rancher-production-failover-root-wildcard-dns" {
  zone_id = "${var.zone_id}"
  name    = "*.finbox.io"
  type    = "A"

  set_identifier = "secondary-finboxio-production-root-wildcard-dns"
  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.rancher-production-maintenance-distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket_object" "013bcd6a3b2bbce663fab28c82d7f9f7c892cd9d" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "text/css"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/index.css")))}"
  key = "fonts/index.css"
  source = "${path.module}/maintenance/fonts/index.css"
}

resource "aws_s3_bucket_object" "03ed60692e0917046cc7288e700c442ce8f80064" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-114.png")))}"
  key = "branding/favicon-114.png"
  source = "${path.module}/maintenance/branding/favicon-114.png"
}

resource "aws_s3_bucket_object" "0560722f8abc9ada94ab06a8babd63fd495edd5a" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-1024-black.png")))}"
  key = "branding/favicon-1024-black.png"
  source = "${path.module}/maintenance/branding/favicon-1024-black.png"
}

resource "aws_s3_bucket_object" "06b4e5adc8952b32389078b94f5916c3c091188d" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-120.png")))}"
  key = "branding/favicon-120.png"
  source = "${path.module}/maintenance/branding/favicon-120.png"
}

resource "aws_s3_bucket_object" "0a2ec76872afb6ba71529de134abec8ff6ba5ac3" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-black.svg")))}"
  key = "branding/favicon-black.svg"
  source = "${path.module}/maintenance/branding/favicon-black.svg"
}

resource "aws_s3_bucket_object" "0bc35b1c0439a12e1e6219fba88878d211d29db2" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-114.jpg")))}"
  key = "branding/favicon-114.jpg"
  source = "${path.module}/maintenance/branding/favicon-114.jpg"
}

resource "aws_s3_bucket_object" "0cf8e923a4dc301df61ddda901f64fd0022d8959" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Bold.woff")))}"
  key = "fonts/font-benton/fonts/BentonSans-Bold.woff"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Bold.woff"
}

resource "aws_s3_bucket_object" "0eaabc6c0a6b5d566b4702bca3b486e17a6c7233" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-500.jpg")))}"
  key = "branding/favicon-500.jpg"
  source = "${path.module}/maintenance/branding/favicon-500.jpg"
}

resource "aws_s3_bucket_object" "0fc3e0db63ea99fefd5d50e2657437705c7094e0" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-57.png")))}"
  key = "branding/favicon-57.png"
  source = "${path.module}/maintenance/branding/favicon-57.png"
}

resource "aws_s3_bucket_object" "132e3d8b7449129e456c5ca01d86c63a2ee8e14a" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Light.svg")))}"
  key = "fonts/font-benton/fonts/BentonSans-Light.svg"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Light.svg"
}

resource "aws_s3_bucket_object" "13a02428872ccf937ec9b328d80165a6cdbb59df" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Regular.woff")))}"
  key = "fonts/font-benton/fonts/BentonSans-Regular.woff"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Regular.woff"
}

resource "aws_s3_bucket_object" "145b9302814f8621bf79e72de2278d7a1dfe3370" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-80.jpg")))}"
  key = "branding/logo-80.jpg"
  source = "${path.module}/maintenance/branding/logo-80.jpg"
}

resource "aws_s3_bucket_object" "190fea76e93f52b694cbc775ad588178cae15601" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Light.eot")))}"
  key = "fonts/font-benton/fonts/BentonSans-Light.eot"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Light.eot"
}

resource "aws_s3_bucket_object" "1914a1f2b685c7e52d4c968fc03ab3a2e4af088c" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-Regular.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-Regular.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-Regular.ttf"
}

resource "aws_s3_bucket_object" "1bbd17a5e39925055c0d029c4a231d8fa409017b" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/finbox-logo-banner.svg")))}"
  key = "branding/finbox-logo-banner.svg"
  source = "${path.module}/maintenance/branding/finbox-logo-banner.svg"
}

resource "aws_s3_bucket_object" "239ba1c93f34860d76324cfd2ec394167bd4dedf" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-22.png")))}"
  key = "branding/logo-22.png"
  source = "${path.module}/maintenance/branding/logo-22.png"
}

resource "aws_s3_bucket_object" "242e8d1d854553b39174fa0603685ba5ff1f1661" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-156.png")))}"
  key = "branding/favicon-156.png"
  source = "${path.module}/maintenance/branding/favicon-156.png"
}

resource "aws_s3_bucket_object" "253fb8998358e31d821dac099c81e5c81a3bdc65" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Regular.eot")))}"
  key = "fonts/font-benton/fonts/BentonSans-Regular.eot"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Regular.eot"
}

resource "aws_s3_bucket_object" "27f94d8a6bc57d6a9770d6c7f8dd12047637c1c0" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Bold.eot")))}"
  key = "fonts/font-benton/fonts/BentonSans-Bold.eot"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Bold.eot"
}

resource "aws_s3_bucket_object" "282bed534ed7f986f9328e0a7703e6303f13918b" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Book.woff")))}"
  key = "fonts/font-benton/fonts/BentonSans-Book.woff"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Book.woff"
}

resource "aws_s3_bucket_object" "2ec4e4e626ab99a59e9456fdd3e52c1dc636c59e" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-152.jpg")))}"
  key = "branding/favicon-152.jpg"
  source = "${path.module}/maintenance/branding/favicon-152.jpg"
}

resource "aws_s3_bucket_object" "34b35f7aaee791b1917f1338980e0559c36265f8" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Medium.woff")))}"
  key = "fonts/font-benton/fonts/BentonSans-Medium.woff"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Medium.woff"
}

resource "aws_s3_bucket_object" "35705e7229d37bd6cd3274dd38cfadc9428e6804" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/fin-surprised.svg")))}"
  key = "branding/fin-surprised.svg"
  source = "${path.module}/maintenance/branding/fin-surprised.svg"
}

resource "aws_s3_bucket_object" "366b5d274de29c388fccf5f39551ef32d36508f2" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "text/css"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/animate.css")))}"
  key = "animate.css"
  source = "${path.module}/maintenance/animate.css"
}

resource "aws_s3_bucket_object" "3c485a9cc5f40d5b0456262ff5587bd9b003f8c1" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Book.svg")))}"
  key = "fonts/font-benton/fonts/BentonSans-Book.svg"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Book.svg"
}

resource "aws_s3_bucket_object" "43661000e6b0d3b000c0d440c546f94aafeabd1a" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-2048.jpg")))}"
  key = "branding/favicon-2048.jpg"
  source = "${path.module}/maintenance/branding/favicon-2048.jpg"
}

resource "aws_s3_bucket_object" "4371ef691863b2f49d7179440a11346cd4097e53" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-16.png")))}"
  key = "branding/favicon-16.png"
  source = "${path.module}/maintenance/branding/favicon-16.png"
}

resource "aws_s3_bucket_object" "438f59c5ed60bc21db1387c2f3944920e584c880" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Book.otf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Book.otf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Book.otf"
}

resource "aws_s3_bucket_object" "44364fb1fb4f32ddb1a8ce79ddcaaad1302be132" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-152.png")))}"
  key = "branding/favicon-152.png"
  source = "${path.module}/maintenance/branding/favicon-152.png"
}

resource "aws_s3_bucket_object" "54d5e879850433aeb8bc3a1a88cab9e20fd928d4" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Book.ttf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Book.ttf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Book.ttf"
}

resource "aws_s3_bucket_object" "550e2ea629a420df36183362038b516bad72b423" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Bold.ttf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Bold.ttf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Bold.ttf"
}

resource "aws_s3_bucket_object" "5701933e83b9cf8b67fef91e1339f96229d0a4d9" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-144.png")))}"
  key = "branding/favicon-144.png"
  source = "${path.module}/maintenance/branding/favicon-144.png"
}

resource "aws_s3_bucket_object" "574f62618d4e10624282c9b0b7ea987917ba9146" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-500.png")))}"
  key = "branding/favicon-500.png"
  source = "${path.module}/maintenance/branding/favicon-500.png"
}

resource "aws_s3_bucket_object" "5ce2de145768ff0127990fbc12dc0448a93805f7" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-Light.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-Light.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-Light.ttf"
}

resource "aws_s3_bucket_object" "5fb4b44bdbf05bf0570e4de6e0d6e2c6d777053f" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-260.jpg")))}"
  key = "branding/favicon-260.jpg"
  source = "${path.module}/maintenance/branding/favicon-260.jpg"
}

resource "aws_s3_bucket_object" "63e871f4eadf1c94e2c2e159793315cad1d4683d" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "text/css"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/index.css")))}"
  key = "fonts/font-benton/index.css"
  source = "${path.module}/maintenance/fonts/font-benton/index.css"
}

resource "aws_s3_bucket_object" "695baa1cc8c472c9f00e1770bcc8c9fcaa8a7468" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-312.jpg")))}"
  key = "branding/favicon-312.jpg"
  source = "${path.module}/maintenance/branding/favicon-312.jpg"
}

resource "aws_s3_bucket_object" "6972e9dd9c89f8c997a4f2deb23e8fec6d7f0712" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-156.jpg")))}"
  key = "branding/favicon-156.jpg"
  source = "${path.module}/maintenance/branding/favicon-156.jpg"
}

resource "aws_s3_bucket_object" "6e5aea55c44fcb9e1c38f8cba00d5beaf273a312" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-16.jpg")))}"
  key = "branding/favicon-16.jpg"
  source = "${path.module}/maintenance/branding/favicon-16.jpg"
}

resource "aws_s3_bucket_object" "6eeecd794e2d51f548eb31bf01bbeaad78b5743d" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-Bold.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-Bold.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-Bold.ttf"
}

resource "aws_s3_bucket_object" "71b7cd2dff4d17eac8ef5b3f91b72df0304aeaad" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Medium.eot")))}"
  key = "fonts/font-benton/fonts/BentonSans-Medium.eot"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Medium.eot"
}

resource "aws_s3_bucket_object" "7581e03881d5c5466261fe451eec27d186af3a2d" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/fin-surprised.png")))}"
  key = "branding/fin-surprised.png"
  source = "${path.module}/maintenance/branding/fin-surprised.png"
}

resource "aws_s3_bucket_object" "78bbba25c8401808e166d23eae724f3b978f9c77" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Regular.otf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Regular.otf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Regular.otf"
}

resource "aws_s3_bucket_object" "7aec0e5cb14a5e6da993022875daf526210bf68b" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-black.svg")))}"
  key = "branding/logo-black.svg"
  source = "${path.module}/maintenance/branding/logo-black.svg"
}

resource "aws_s3_bucket_object" "801de3fd97ee4ef91472d0eaa215823460826a8a" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/vnd.microsoft.icon"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon.ico")))}"
  key = "branding/favicon.ico"
  source = "${path.module}/maintenance/branding/favicon.ico"
}

resource "aws_s3_bucket_object" "80256c5a3aea0477cd34f91526e2618d8648cd7f" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Bold.otf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Bold.otf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Bold.otf"
}

resource "aws_s3_bucket_object" "8142d8fadca7785c2bcfe795202f25da2330697e" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-text-80.png")))}"
  key = "branding/logo-text-80.png"
  source = "${path.module}/maintenance/branding/logo-text-80.png"
}

resource "aws_s3_bucket_object" "815acbecbf22760fde9091e801a5ede51cf653f7" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Bold.svg")))}"
  key = "fonts/font-benton/fonts/BentonSans-Bold.svg"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Bold.svg"
}

resource "aws_s3_bucket_object" "851008581c3dcc9c6227e25c05fa183cff1dd2c5" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-2048.png")))}"
  key = "branding/favicon-2048.png"
  source = "${path.module}/maintenance/branding/favicon-2048.png"
}

resource "aws_s3_bucket_object" "880e784dd8256a699eb14d87c1f8678a3e6e5f7b" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-1024-black.jpg")))}"
  key = "branding/favicon-1024-black.jpg"
  source = "${path.module}/maintenance/branding/favicon-1024-black.jpg"
}

resource "aws_s3_bucket_object" "88e5c2c5ef0b469b454912e8dd317206e4b8bf47" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-260.png")))}"
  key = "branding/favicon-260.png"
  source = "${path.module}/maintenance/branding/favicon-260.png"
}

resource "aws_s3_bucket_object" "890fae0f2b5b51c557a4f6b9d447a1deb7378255" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "text/plain; charset=utf-8"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/LICENSE.txt")))}"
  key = "fonts/font-roboto_mono/LICENSE.txt"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/LICENSE.txt"
}

resource "aws_s3_bucket_object" "92a88ff56e919e20fc2dd057deb295df98fbe5b9" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Medium.ttf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Medium.ttf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Medium.ttf"
}

resource "aws_s3_bucket_object" "9580c3f87db04224628c7129bb116fe16873faac" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-80-black.png")))}"
  key = "branding/logo-80-black.png"
  source = "${path.module}/maintenance/branding/logo-80-black.png"
}

resource "aws_s3_bucket_object" "97368c6a4f291d05456b80522364f355a57e77f4" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/thumbnail.png")))}"
  key = "branding/thumbnail.png"
  source = "${path.module}/maintenance/branding/thumbnail.png"
}

resource "aws_s3_bucket_object" "9f2d588b478b94d5ae5c56582736a6a034b692ac" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-57.jpg")))}"
  key = "branding/favicon-57.jpg"
  source = "${path.module}/maintenance/branding/favicon-57.jpg"
}

resource "aws_s3_bucket_object" "a096a4742a3e2b8917c92f40f285cfa9b4a7c7a0" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-Medium.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-Medium.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-Medium.ttf"
}

resource "aws_s3_bucket_object" "a92924a4e87f48aac400229388ce149c87defe0f" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-22.jpg")))}"
  key = "branding/logo-22.jpg"
  source = "${path.module}/maintenance/branding/logo-22.jpg"
}

resource "aws_s3_bucket_object" "af746041578694c1676d2d8ebced1711fffa6539" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-circle.png")))}"
  key = "branding/favicon-circle.png"
  source = "${path.module}/maintenance/branding/favicon-circle.png"
}

resource "aws_s3_bucket_object" "b208c99820f44818aaddf97c34280ec0b49fc533" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/fin-happy.png")))}"
  key = "branding/fin-happy.png"
  source = "${path.module}/maintenance/branding/fin-happy.png"
}

resource "aws_s3_bucket_object" "b8ed776cc1b2213dfe040dd7d1afeebe3e58ba69" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Light.ttf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Light.ttf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Light.ttf"
}

resource "aws_s3_bucket_object" "bb6a67c9b38aea0699dcc6492726e4e095b23d71" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-MediumItalic.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-MediumItalic.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-MediumItalic.ttf"
}

resource "aws_s3_bucket_object" "bd7504fa66a29dad97b6ec6bf6dee587d937fb03" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Regular.svg")))}"
  key = "fonts/font-benton/fonts/BentonSans-Regular.svg"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Regular.svg"
}

resource "aws_s3_bucket_object" "c0b1f570b87d7b5328e67030425d87cd48bfbbf4" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Medium.svg")))}"
  key = "fonts/font-benton/fonts/BentonSans-Medium.svg"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Medium.svg"
}

resource "aws_s3_bucket_object" "c62aea00dcbf7df449eacafe3f34c55a369af0d7" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-1024.jpg")))}"
  key = "branding/favicon-1024.jpg"
  source = "${path.module}/maintenance/branding/favicon-1024.jpg"
}

resource "aws_s3_bucket_object" "cb62928f4dfb50b9bd66c8e4b1f9962cab25a11b" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/fin2.png")))}"
  key = "branding/fin2.png"
  source = "${path.module}/maintenance/branding/fin2.png"
}

resource "aws_s3_bucket_object" "d600c7d6337d6a020c08c3cd0d2b1a71079621b3" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/vnd.microsoft.icon"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-circle.ico")))}"
  key = "branding/favicon-circle.ico"
  source = "${path.module}/maintenance/branding/favicon-circle.ico"
}

resource "aws_s3_bucket_object" "d66e8cd4d677d66b569221a8438d49e680019015" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-1024.png")))}"
  key = "branding/favicon-1024.png"
  source = "${path.module}/maintenance/branding/favicon-1024.png"
}

resource "aws_s3_bucket_object" "d6c865a76f0623bfc8e8fff7b0975779fe8dacd4" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Regular.ttf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Regular.ttf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Regular.ttf"
}

resource "aws_s3_bucket_object" "d93bd961c6e84c8ed077793ea67897883d6e6638" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo.svg")))}"
  key = "branding/logo.svg"
  source = "${path.module}/maintenance/branding/logo.svg"
}

resource "aws_s3_bucket_object" "db85dc6d1774c59a7e609415d169b945c692199f" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Light.woff")))}"
  key = "fonts/font-benton/fonts/BentonSans-Light.woff"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Light.woff"
}

resource "aws_s3_bucket_object" "dd0892b3558eeef162d8ffd40978ab0a2c9020b3" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Light.otf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Light.otf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Light.otf"
}

resource "aws_s3_bucket_object" "dd946703a1a09049940390be20c04956a032c5a5" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-312.png")))}"
  key = "branding/favicon-312.png"
  source = "${path.module}/maintenance/branding/favicon-312.png"
}

resource "aws_s3_bucket_object" "dda291d15bd03fc8f706f676cc7fdcca4d8d462e" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-ThinItalic.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-ThinItalic.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-ThinItalic.ttf"
}

resource "aws_s3_bucket_object" "dfbdc0a2de76a06772b74b21516a083912a37037" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Medium.otf")))}"
  key = "fonts/font-benton/fonts/BentonSans-Medium.otf"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Medium.otf"
}

resource "aws_s3_bucket_object" "e22421fcd9f470ed708ff4546b6141018f12ed08" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/svg+xml"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-circle.svg")))}"
  key = "branding/favicon-circle.svg"
  source = "${path.module}/maintenance/branding/favicon-circle.svg"
}

resource "aws_s3_bucket_object" "e2a5006addd7f47f88ad0d1f20f8f74ebc34b367" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-text-80.jpg")))}"
  key = "branding/logo-text-80.jpg"
  source = "${path.module}/maintenance/branding/logo-text-80.jpg"
}

resource "aws_s3_bucket_object" "e370841b2a788cd29973b583336197822ce7b6a3" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-LightItalic.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-LightItalic.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-LightItalic.ttf"
}

resource "aws_s3_bucket_object" "e52a0e8511d37879a180b44d44a8124d6587902a" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "text/css"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/maintenance.css")))}"
  key = "maintenance.css"
  source = "${path.module}/maintenance/maintenance.css"
}

resource "aws_s3_bucket_object" "e8948c6354daaefedf0836b094b3987d90336b5f" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/png"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-80.png")))}"
  key = "branding/logo-80.png"
  source = "${path.module}/maintenance/branding/logo-80.png"
}

resource "aws_s3_bucket_object" "e8ac53ad13d7126d09d94ed6dd9baa48115c818a" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-120.jpg")))}"
  key = "branding/favicon-120.jpg"
  source = "${path.module}/maintenance/branding/favicon-120.jpg"
}

resource "aws_s3_bucket_object" "e9b8bfc6ea635642c0846f59735fe0799df91a1c" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-Thin.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-Thin.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-Thin.ttf"
}

resource "aws_s3_bucket_object" "ec994e19fbd12ea3f44e0ba2980609d796742afc" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-BoldItalic.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-BoldItalic.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-BoldItalic.ttf"
}

resource "aws_s3_bucket_object" "f10bb1af02b8ac824941c9ac3262a8e914491bc7" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-roboto_mono/RobotoMono-Italic.ttf")))}"
  key = "fonts/font-roboto_mono/RobotoMono-Italic.ttf"
  source = "${path.module}/maintenance/fonts/font-roboto_mono/RobotoMono-Italic.ttf"
}

resource "aws_s3_bucket_object" "f2c7e2d7963f8809e997d08ac342dd6c05b1e73c" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/logo-80-black.jpg")))}"
  key = "branding/logo-80-black.jpg"
  source = "${path.module}/maintenance/branding/logo-80-black.jpg"
}

resource "aws_s3_bucket_object" "f6013a00b362253c64368d6eebc50ea2131754e2" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "text/html; charset=utf-8"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/index.html")))}"
  key = "index.html"
  source = "${path.module}/maintenance/index.html"
}

resource "aws_s3_bucket_object" "f7806c7e4b4e5afe304fd77cb3b41ea5a2c99a98" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/vnd.microsoft.icon"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/favicon.ico")))}"
  key = "favicon.ico"
  source = "${path.module}/maintenance/favicon.ico"
}

resource "aws_s3_bucket_object" "f7f6bbca325f7f7eb63a002de5ed50c136196c0a" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "application/octet-stream"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/fonts/font-benton/fonts/BentonSans-Book.eot")))}"
  key = "fonts/font-benton/fonts/BentonSans-Book.eot"
  source = "${path.module}/maintenance/fonts/font-benton/fonts/BentonSans-Book.eot"
}

resource "aws_s3_bucket_object" "fa764df9d19057e3a48e1636ee873931ca15d0f5" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-circle.jpg")))}"
  key = "branding/favicon-circle.jpg"
  source = "${path.module}/maintenance/branding/favicon-circle.jpg"
}

resource "aws_s3_bucket_object" "fb0d3c6bac81ec880b07d1778b4078be45ac2e41" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "image/jpeg"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/branding/favicon-144.jpg")))}"
  key = "branding/favicon-144.jpg"
  source = "${path.module}/maintenance/branding/favicon-144.jpg"
}

resource "aws_s3_bucket_object" "f90c21f33c51ec68ab09e8db8b4078be941a2f92" {
  bucket = "${aws_s3_bucket.rancher-production-maintenance-bucket.bucket}"
  content_type = "text/html"
  etag = "${md5(file(format("%s/%s", path.module, "maintenance/404.html")))}"
  key = "404.html"
  source = "${path.module}/maintenance/404.html"
}
