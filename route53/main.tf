resource "aws_route53_zone" "route53_host_zone" {
    name = "roomfit.shop"
    comment = "roomfit.shop"
}

resource "aws_route53_record" "route53_record_a_eb" {
    zone_id = aws_route53_zone.route53_host_zone.zone_id
    name    = "roomfit.shop"
    type    = "A"
    
    alias {
        name = "${aws_elastic_beanstalk_environment.beanstalkappenv.cname}"
        zone_id = "Z3JE5OI70TWKCP"
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "route53_record_a_eb_www" {
    zone_id = aws_route53_zone.route53_host_zone.zone_id
    name    = "www.roomfit.shop"
    type    = "A"
    
    alias {
        name = "${aws_elastic_beanstalk_environment.beanstalkappenv.cname}"
        zone_id = "Z3JE5OI70TWKCP"
        evaluate_target_health = true
    }
}

output "nameservers" {
    value = aws_route53_zone.route53_host_zone.name_servers
}
