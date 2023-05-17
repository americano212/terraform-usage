variable "domain_name" {
    type        = string
    default     = "test.ddakzip.shop"
    description = "Fully domain name to deploy Web services"
}

variable "validation_domain_name" {
    type        = string
    default     = "ddakzip.shop"
    description = "Domain name for validation on acm"
}
