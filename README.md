# Event-Driven Application using SQS, SNS & Lambda
![Screenshot 2025-03-10 003749](https://github.com/user-attachments/assets/99e3f9bc-0c08-4706-a913-c42091ebb1d2)

## Overview

This project implements an event-driven architecture using AWS Lambda, Amazon SQS and Amazon SNS. It demonstrates how messages flow from SNS to SQS and trigger a Lambda function to process events asynchronously.

## Features

- **Decoupled Architecture**: Ensures scalable and event-driven processing.
- **Asynchronous Processing**: Messages are queued and processed independently.
- **AWS Native Services**: Uses fully managed services for high availability.  
- **Secure IAM Policies**: Follows least-privilege security principles.
- **Terraform**: Infrastructure as Code (IaC) for seamless deployment.

## Architecture

- **SNS Topic**: Publishes messages to subscribers.
- **SQS Queue**: Receives messages from SNS.
- **Lambda Function**: Consumes and processes messages from SQS.
- **IAM Role**: Grants necessary permissions.

## IAM Policies Used

- AWSLambdaBasicExecutionRole
- AmazonSQSFullAccess
- AmazonSNSFullAccess
- Custom inline policy for Lambda → SQS message retrieval.

## Deployment

1. Clone the Repository
```
git clone https://github.com/your-username/event-driven-sqs-sns-lambda.git
cd event-driven-sqs-sns-lambda
```
2. Setup AWS Credentials
```
aws configure
```
3. Deploy using Terraform
```
terraform init
terraform apply -auto-approve
```
4. Test the Setup
- Publish a test message to SNS:
```
aws sns publish --topic-arn <SNS_TOPIC_ARN> --message "Hello from SNS!"
```
- Check Lambda logs in Amazon CloudWatch.
5. Cleanup
```
terraform destroy -auto-approve
```

# Contributors
Ali H. Mughal *(AWS. Solutions Architect)*
