resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
    comment = "cloudfront_origin_access_identity comment"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name = aws_s3_bucket.deploy_bucket.bucket_domain_name
        origin_id   = aws_s3_bucket.deploy_bucket.id

        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
        }

        origin_shield {
            enabled = true
            origin_shield_region = "ap-northeast-2"
        }
    }

    enabled             = true
    is_ipv6_enabled     = true
    comment             = "test comment"
    default_root_object = "index.html"

    aliases = [var.domain_name]

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = aws_s3_bucket.deploy_bucket.id

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

    ordered_cache_behavior {
        path_pattern     = "/*"
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = aws_s3_bucket.deploy_bucket.id

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        min_ttl                = 0
        default_ttl            = 86400
        max_ttl                = 31536000
        compress               = true
        viewer_protocol_policy = "redirect-to-https"
    }

    price_class = "PriceClass_200"

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations        = ["US", "CA", "GB", "DE"]
        }
    }

    tags = {
        Environment = "production"
    }

    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate_validation.example.certificate_arn
        ssl_support_method = "sni-only"
    }
}