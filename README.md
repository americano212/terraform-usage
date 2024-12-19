# 🖥 Terraform Usage Repository
📌 Case-by-case Teraform Usage Repository

## 🧿 Case
|   Case   | Link | Note |
|----------|------|------|
| S3+CDN 정적 웹페이지 배포 | [s3-cloudfront-deploy](https://github.com/americano212/terraform-usage/tree/main/s3-cloudfront-deploy) | -------- |
| 스팟 인스턴스 호출(일회성) | [spot-instance](https://github.com/americano212/terraform-usage/tree/main/spot-instance) | -------- |
| MySQL DB 생성 | [rds-mysql-database](https://github.com/americano212/terraform-usage/tree/main/rds-mysql-database) | -------- |
| Lambda+API Gateway(REST API) 생성 | [rest-api-lambda-api-gateway](https://github.com/americano212/terraform-usage/tree/main/rest-api-lambda-api-gateway) | -------- |
| 파일 업로드용 S3 버킷 생성 | [file-upload-s3](https://github.com/americano212/terraform-usage/tree/main/file-upload-s3) | -------- |

## 🔨 Guide
### 환경변수 세팅
```shell
# Unix/Linux
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_REGION=""

# Windows
SET AWS_ACCESS_KEY_ID=
SET AWS_SECRET_ACCESS_KEY=
SET AWS_REGION=
```

### provider.tf 생성
```python
terraform {
  backend "s3" {
    bucket         = "<s3-bucket-name>" # s3 버킷명
    key            = "<service-key>/terraform.tfstate" # tfstate 저장 경로
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-tfstate-lock" # dynamodb table 이름
  }
}

provider "aws" {}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
}
```

### Terraform CLI
```bash
terraform init

terraform plan
terraform apply

terraform destroy
```