provider "aws" {
  profile = "default"
}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
}