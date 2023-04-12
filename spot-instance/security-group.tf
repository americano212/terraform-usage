resource "aws_security_group" "sg_crawling" {
    name = "Crawling Security Group"
    tags = { Name = "Crawling Security Group" }
}

resource "aws_security_group_rule" "sgr-in-ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.sg_crawling.id}"
}

resource "aws_security_group_rule" "sgr-out-http" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.sg_crawling.id}"
}
