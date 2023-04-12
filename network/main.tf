resource "aws_vpc" "terraform_vpc" {
    cidr_block = "10.0.0.0/16" #IPv4 CIDR Block
    enable_dns_hostnames = true #DNS Hostname 사용 옵션, 기본은 false
    tags =  { 
        Name = "terraform-vpc" #tag 입력
    } 
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "terra-igw" {
    vpc_id = aws_vpc.terraform_vpc.id #어느 VPC와 연결할 것인지 지정
    tags = { Name = "terraform-igw"}  #태그 설정
}

# Subnet Public
resource "aws_subnet" "terra-sub-public1" {
    vpc_id = aws_vpc.terraform_vpc.id #위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.10.0/24" #IPv4 CIDER 블럭
    availability_zone = "ap-northeast-2a" #가용영역 지정
    map_public_ip_on_launch = true #퍼블릭 IP 자동 부여 설정
    tags = { Name = "terra-sub-public1"} #태그 설정

}

resource "aws_subnet" "terra-sub-public2" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block  = "10.0.20.0/24"
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = true
    tags = { Name = "terra-sub-public2"}
}


# public routing
resource "aws_route_table" "terra-public1" {
  vpc_id = aws_vpc.terraform_vpc.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id #Internet Gateway 별칭 입력
  }
  tags = { Name = "terra-public1" } #태그 설정
}

resource "aws_route_table" "terra-public2" {
  vpc_id = aws_vpc.terraform_vpc.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id #Internet Gateway 별칭 입력
  }
  tags = { Name = "terra-public2" } #태그 설정
}

resource "aws_route_table_association" "terra-routing-public1" {
  subnet_id      = aws_subnet.terra-sub-public1.id
  route_table_id = aws_route_table.terra-public1.id
}

resource "aws_route_table_association" "terra-routing-public2" {
  subnet_id      = aws_subnet.terra-sub-public2.id
  route_table_id = aws_route_table.terra-public2.id
}


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