output "vpc_id" {
    value       = aws_vpc.terraform_vpc.id
    description = "vpc_id"
}

output "subnet1_id" {
    value       = aws_subnet.terra-sub-public1.id
    description = "subnet1_id"
}

output "subnet2_id" {
    value       = aws_subnet.terra-sub-public2.id
    description = "subnet2_id"
}

output "beanstalkappenv-dns" {
    value       = aws_elastic_beanstalk_environment.beanstalkappenv.cname
    description = "cname_prefix"
}