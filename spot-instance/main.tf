variable "spot_instance_type" {
  type        = string
  default     = "t3.medium"
}

resource "aws_key_pair" "key_pair" {
  key_name = "key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_spot_instance_request" "crawling_spot" {
    ami           = "ami-04cebc8d6c4f297a3" # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-03-25
    spot_price    = "0.016"
    spot_type     = "one-time"
    instance_type = var.spot_instance_type
    instance_interruption_behavior  = "terminate"
    key_name = aws_key_pair.key_pair.key_name
    vpc_security_group_ids = [aws_security_group.sg_crawling.id]
    tags = {
        Name = "crawling_spot"
    }
}

output "public_ip" {
  value       = aws_spot_instance_request.crawling_spot.public_ip
  description = "crawling_spot"
}

output "public_dns" {
  value       = aws_spot_instance_request.crawling_spot.public_dns
  description = "crawling_spot"
}