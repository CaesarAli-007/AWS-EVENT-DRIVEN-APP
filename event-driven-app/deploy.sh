#!/bin/bash

# Variables (Modify These)
LAMBDA_FUNCTION_NAME="EventDrivenLambda"
IAM_ROLE_NAME="EventDrivenLambdaRole"
SQS_QUEUE_NAME="EventQueue"
SNS_TOPIC_NAME="EventTopic"
LAMBDA_ZIP="lambda_function.zip"
AWS_REGION="us-east-1"

echo "🚀 Deploying Event-Driven Architecture..."

# Step 1: Create IAM Role for Lambda
echo "🛠️ Creating IAM Role..."
IAM_ROLE_ARN=$(aws iam create-role --role-name $IAM_ROLE_NAME \
  --assume-role-policy-document file://iam_policies.json \
  --query 'Role.Arn' --output text)

aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole

echo "✅ IAM Role Created: $IAM_ROLE_ARN"

# Step 2: Create SQS Queue
echo "📩 Creating SQS Queue..."
SQS_QUEUE_URL=$(aws sqs create-queue --queue-name $SQS_QUEUE_NAME --query 'QueueUrl' --output text)
SQS_QUEUE_ARN=$(aws sqs get-queue-attributes --queue-url $SQS_QUEUE_URL --attribute-name QueueArn --query 'Attributes.QueueArn' --output text)

echo "✅ SQS Queue Created: $SQS_QUEUE_URL"

# Step 3: Create SNS Topic
echo "📢 Creating SNS Topic..."
SNS_TOPIC_ARN=$(aws sns create-topic --name $SNS_TOPIC_NAME --query 'TopicArn' --output text)

echo "✅ SNS Topic Created: $SNS_TOPIC_ARN"

# Step 4: Subscribe SQS to SNS
echo "🔗 Subscribing SQS to SNS..."
aws sns subscribe --topic-arn $SNS_TOPIC_ARN --protocol sqs --notification-endpoint $SQS_QUEUE_ARN

# Step 5: Deploy Lambda Function
echo "⚡ Deploying Lambda Function..."
LAMBDA_ARN=$(aws lambda create-function --function-name $LAMBDA_FUNCTION_NAME \
  --runtime python3.9 --role $IAM_ROLE_ARN \
  --handler lambda_function.lambda_handler --timeout 10 \
  --zip-file fileb://$LAMBDA_ZIP --query 'FunctionArn' --output text)

echo "✅ Lambda Function Deployed: $LAMBDA_ARN"

# Step 6: Grant SQS Permissions to Lambda
echo "🔐 Adding SQS Permissions to Lambda..."
aws lambda add-permission --function-name $LAMBDA_FUNCTION_NAME \
  --statement-id AllowSQSTrigger \
  --action "lambda:InvokeFunction" \
  --principal "sqs.amazonaws.com" \
  --source-arn $SQS_QUEUE_ARN

# Step 7: Create Event Source Mapping (Trigger Lambda from SQS)
echo "🔗 Linking Lambda to SQS..."
aws lambda create-event-source-mapping --function-name $LAMBDA_FUNCTION_NAME \
  --batch-size 10 --event-source-arn $SQS_QUEUE_ARN

echo "🚀 Deployment Complete!"

# How to Use?

# 1) Make sure you have AWS CLI configured (aws configure).
# 2) Modify the placeholders in the script (Bucket Name, Lambda ZIP, etc.).
# 3) Save it as deploy.sh and make it executable
#    "chmod +x deploy.sh"
# 4) Run the script
#    "./deploy.sh"