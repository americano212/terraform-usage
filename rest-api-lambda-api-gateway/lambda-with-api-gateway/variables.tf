variable "symbols" { # TODO Change this!
  type = list(string)
  default = [
    "lambda-naming-1", "lambda-naming-2"
  ]
  description = "Symbols for lambda & api-gateway"
}

variable "querystring_each_symbols" {
  type        = list(list(string))
  default     = [["query1", "query2"], ["username", "icon_emoji"]]
  description = "Querystring each symbols when create API-Gateway"
}

variable "s3_bucket_name" {
  type    = string
  default = "<bucket-name>"
}

# variable "accountId"{
#     type    = string
#     default = ""
# }
