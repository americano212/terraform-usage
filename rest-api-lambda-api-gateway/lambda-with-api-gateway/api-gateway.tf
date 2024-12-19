resource "aws_api_gateway_rest_api" "api" {
  name = "vocavoca"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

resource "aws_api_gateway_resource" "resource" {
  count = length(var.symbols)

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.symbols[count.index]
}

resource "aws_api_gateway_request_validator" "request_validator" {
  name                        = "request-validator"
  rest_api_id                 = aws_api_gateway_rest_api.api.id
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "method" {
  count = length(var.symbols)

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource[count.index].id
  http_method   = "GET"
  authorization = "NONE"

  request_validator_id = aws_api_gateway_request_validator.request_validator.id

  request_parameters = { for key in var.querystring_each_symbols[count.index] : "method.request.querystring.${key}" => true }
}

resource "aws_api_gateway_method_response" "method_response" {
  count = length(var.symbols)

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource[count.index].id
  http_method = aws_api_gateway_method.method[count.index].http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}


resource "aws_api_gateway_integration" "integration" {
  count       = length(var.symbols)
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.method[count.index].resource_id
  http_method = aws_api_gateway_method.method[count.index].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function[count.index].invoke_arn
  timeout_milliseconds    = 29000
}


resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource[*].id,
      aws_api_gateway_method.method[*].id,
      aws_api_gateway_integration.integration[*].id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "api_endpoints" {
  value = [for resource in aws_api_gateway_resource.resource : "${aws_api_gateway_deployment.deployment.invoke_url}/${resource.path_part}"]
}

