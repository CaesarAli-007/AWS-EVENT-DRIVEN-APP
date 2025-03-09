provider "aws" {
  region = "us-east-1"  # Change to your preferred AWS region
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "EventDrivenLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda_basic_execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# SQS Queue
resource "aws_sqs_queue" "event_queue" {
  name = "EventQueue"
}

# SNS Topic
resource "aws_sns_topic" "event_topic" {
  name = "EventTopic"
}

# Subscribe SQS to SNS
resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.event_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.event_queue.arn
}

# Lambda Function
resource "aws_lambda_function" "event_lambda" {
  function_name    = "EventDrivenLambda"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 10
  filename        = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Allow SQS to trigger Lambda
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.event_queue.arn
  function_name    = aws_lambda_function.event_lambda.arn
  batch_size       = 10
}

# Output Variables
output "sqs_queue_url" {
  description = "SQS Queue URL"
  value       = aws_sqs_queue.event_queue.url
}

output "sns_topic_arn" {
  description = "SNS Topic ARN"
  value       = aws_sns_topic.event_topic.arn
}

output "lambda_function_arn" {
  description = "Lambda Function ARN"
  value       = aws_lambda_function.event_lambda.arn
}
