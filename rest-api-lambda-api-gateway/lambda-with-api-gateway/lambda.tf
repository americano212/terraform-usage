data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda_function" {
  count = length(var.symbols)

  function_name = var.symbols[count.index]
  role          = aws_iam_role.iam_for_lambda.arn

  s3_bucket = var.s3_bucket_name
  s3_key    = "${var.symbols[count.index]}.zip"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  timeout = 60
}

resource "aws_lambda_permission" "permission" {
  count = length(var.symbols)

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function[count.index].arn
  principal     = "apigateway.amazonaws.com"

  source_arn = format("%s%s", aws_api_gateway_rest_api.api.execution_arn, "/*/${aws_api_gateway_method.method[count.index].http_method}${aws_api_gateway_resource.resource[count.index].path}")
  # source_arn = "arn:aws:execute-api:ap-northeast-2:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method[count.index].http_method}${aws_api_gateway_resource.resource[count.index].path}"
}

