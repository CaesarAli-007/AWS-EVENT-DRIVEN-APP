### SQS Queue Setup Guide

#### Step 1: Create an SQS Queue
1. Go to AWS Management Console → Search **SQS**.
2. Click **Create queue**.
3. Choose **Standard Queue** (or FIFO if required).
4. Provide a name (e.g., `EventDrivenQueue`).
5. Configure settings as needed.
6. Click **Create Queue**.

#### Step 2: Set Permissions for Lambda
1. Navigate to the newly created queue.
2. Go to the **Access Policy** section.
3. Edit and add permissions for the Lambda function to receive messages.

#### Step 3: Copy the Queue ARN
1. Find the **Queue ARN** under the **Details** section.
2. Save it for configuring Lambda later.