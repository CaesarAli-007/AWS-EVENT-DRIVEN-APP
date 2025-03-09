import json
import boto3

def lambda_handler(event, context):
    sqs = boto3.client('sqs')
    sns = boto3.client('sns')
    
    queue_url = "<YOUR_SQS_QUEUE_URL>"
    topic_arn = "<YOUR_SNS_TOPIC_ARN>"
    
    messages = []
    
    for record in event['Records']:
        body = json.loads(record['body'])
        messages.append(body)
    
    if messages:
        sns.publish(
            TopicArn=topic_arn,
            Message=json.dumps(messages),
            Subject='New Messages in SQS'
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Processed messages successfully!')
    }
