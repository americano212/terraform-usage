data "aws_route53_zone" "route53_host_zone" {
    name = var.validation_domain_name
}

resource "aws_route53_record" "route53_record_a_eb_test" {
    zone_id = data.aws_route53_zone.route53_host_zone.zone_id
    name    = var.domain_name
    type    = "A"

    alias {
        name = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
        zone_id = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
        evaluate_target_health = false
    }
}