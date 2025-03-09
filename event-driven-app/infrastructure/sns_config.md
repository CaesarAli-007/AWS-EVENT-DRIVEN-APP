### SNS Topic Setup Guide

#### Step 1: Create an SNS Topic
1. Go to AWS Management Console → Search **SNS**.
2. Click **Create topic**.
3. Choose **Standard** (or FIFO if needed).
4. Provide a name (e.g., `EventDrivenTopic`).
5. Click **Create topic**.

#### Step 2: Subscribe SQS to SNS
1. Open the SNS topic.
2. Click **Create Subscription**.
3. Choose **Protocol: Amazon SQS**.
4. Select your **SQS Queue**.
5. Click **Create Subscription**.

#### Step 3: Copy the Topic ARN
1. Find the **Topic ARN** under the **Details** section.
2. Save it for configuring Lambda later.