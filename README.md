# AWS_MSK_DataPipeline

<p align="center">
This one project aims to build a simple end to end Kafka data streaming pipline. 
</p>

***

**EXAMPLE:**
<p>
Say your boss at your company is looking for some questions. They need someone to quickly answer a singular question. "How much did we spend between ads on this website and that website?" "What caused leads to spike this week?". Of course, you can visualize these questions with a dashboard and look at overtime results, but for this particular scenario, an immediate and specific answer is needed.
  </p>

**SOLUTION:**
<p>
Build a serverless, end to end data streaming pipeline that will ingest data for many purposes including ad-hoc analytics. This pipeline will make it very efficient to migrate, build, and run real-time data streaming applications on Apache Kafka. Through serverless and managed services on AWS, data sourcing, exploring, and visualizing such data will help businesses with real-time needs with little interference as possible. Allowing you to use the pipeline for multiple solutions.
 </p>


 **OBJECTIVE:**

* FLEXIBLE INFRASTRUCTURE
* NO UPFRONT COST
* SERVERLESS
* FAAS
* PAAS
</p>

**AWS Cloud services used:**
* EC2
* API GATEWAY
* SQS
* LAMBDA
* MSK (MANAGED STREAMING FOR APACHE KAFKA)
* KINESIS FIREHOUSE
* S3
* GLUE
* ATHENA
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDataPipeline.png"  title="hover text">
  </p>

***

<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP1.png" width="700"  title="hover text">
 </p>
 <p align="center">
  First create a new private VPC cloud with the follow settings. I used a IPv4 CIDR 10.0.0.0/16.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP2.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Choose the newly created VPC and create two public and two private subnets. Choose us-east-1a AZ to host one public and one private. Choose us-east-1b to host the other public and private. The private subnets will host the MSK clusters that will be created later on.
  For the subnets, I assigned the CIDRs 10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 for the subnets as you will see in the following images.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP3.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP4.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP5.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP6.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP7.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP8.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Create an internet gateway and attach to the VPC.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP9.png" width="700"  title="hover text">
 </p>
 <p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP10.png" width="700"  title="hover text">
 </p>
  <p align="center">
  Create two route tables. one private and one public. Attach the VPC cloud create to both.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP11.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to public route table , edit routes, and add the internet gateway as a targert for the destination. The public subnet will allow traffic from the web.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP12.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Edit subnet associations and add the two public subnets created to it.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP13.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Perform the same tasks for the private route table, except do not add the internet gateway. The internet should not be allowed to access the MSK cluster that will associated with the subnets of this route table.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP14.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP15.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP16.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Instead of the internet gateway. We will associate a NAT gateway to the private subnets. This will allow for information to be sent to the private subnets without interacting with the internet directly for saefty precautions. Basically, the NAT will talk to the public subnets for the MSK Clusters. Allocate an Elastic IP to the NAT.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP17.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to the private route table and attach the NAT gateway.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP18.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to MSK service and create the MSK cluster. Choose Custom create and Provisioned as the cluster type.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP19.png" width="700"  title="hover text">
 </p>
 <p align="center">
  * Choose Apache version: 2.8.1
  * Broker type: kafka.t3.small
  * Number of zones: 2
  * Brokers per zone: 1
</p>
  
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP20.png" width="700"  title="hover text">
 </p>
 
 <p align="center">
  * Amazon EBS Storage per broker: 1 GiB (demo purposes)
  * EBS storage only
  </p>
  
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP21.png" width="700"  title="hover text">
 </p>

<p align="center">
  Choose VPC that was created.
  * Number of zones : 2 (Create two AZ so choose this along with one private subnet for each zone.)
  * First zone : us-east-1a
  * Second zone : us-east-1b
  * Public access : Off
  </p>
  
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP23.png" width="700"  title="hover text">
 </p>
 
 <p align="center">
  * Unauthenticated access
  * Plain text
  * TLS encryption 
  </p>
  
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP24.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Choose basic monitoring
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP25.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Create the first lambda function. This will be the Kafka producer. This function will be triggered by SQS POSTs, and the job of this lambda will be to send these requests to the MSK cluster in the private subnets. This AWS Lambda function acts as a bridge between an Amazon SQS queue and a Kafka topic, allowing messages to be seamlessly transferred between the two systems.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP26.png" width="700"  title="hover text">
 </p>
 <p align="center">
  
** Here the code reads: **
  
* First, it imports the necessary modules: time, json, and KafkaProducer from the kafka library.

* It defines the Kafka topic name by setting the 'topic_name' variable to a string.

* It initializes a KafkaProducer instance, passing in a list of Kafka broker URLs and a value_serializer that converts Python objects to JSON.

* The lambda_handler function is defined, which is the main entry point for the AWS Lambda function. It takes two arguments: 'event' and 'context'.

* The function prints the 'event' object to the console, which contains the SQS message that triggered the Lambda function.

* The function loops over each record in the 'Records' field of the 'event' object.

* For each record, the function retrieves the message body using the 'body' field, which contains a JSON string representation of the SQS message.

* The function uses the json.loads method to deserialize the JSON string into a Python object.

* The function prints the deserialized message to the console.

* Finally, the function publishes the message to the Kafka topic using the producer.send() method and flushes the producer to ensure that all messages are sent to Kafka.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP27.png" width="700"  title="hover text">
 </p>
  <p align="center">
  On the left-hand side of the lambda function, click VPC. Choose the private subnets so that the lambda function can access it the private MSK cluster.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP28.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Now, go back to lambda, and create a lambda layer. A layer is essentially a ZIP archive that contains libraries, a custom runtime, or other dependencies, which can be uploaded independently of the function code. It allows you to reuse common pieces of code, such as external libraries, across multiple functions. This can help you to reduce the size of your function code and simplify the development process. It can improve the performance of your Lambda functions by reducing the size of the deployment package, as well as reducing the cold start time for your functions. We want to inmport kafka and python libraries.
  
 Make sure Python 3.8 is selected as the runtime so that it matches the lambda function.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP29.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go back to the kafka producer kambda and select Add Layer. Specify the ARN of the lambda layer that was just created.
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP30.png" width="700"  title="hover text">
 </p>
  <p align="center">
  Go to SQS and create a queue. This will deliver messages to the producer lambda. The visibility timeout to 240. This will be higher than than how long the lambda function runs, so that the sqs does not think the lambda is down and decides to send the message back.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP31.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to API Gateway and creat an API. This API will post messages to SQS. Now to create the roles to allow access to perform the task.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP32.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Select AWS service and select API Gateway as the use case.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP33.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to Role and create a role to attach to the API Gateway.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP34.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Attach policies to the role :
  AmazonSQSFullAccess.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP35.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Create a POST route with the path of /publisher.
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP36.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP37.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP38.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Creat and attach an intergration. Select SQS as the integration. SendMessage will be the Integration action.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP39.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Input the URL of the SQS queue. In the "Message body" this parameter is used in the code to extract the message body from the SQS message and process it accordingly. in the AWS Lambda function code that was made earlier, the sqs_message variable is assigned the value of the message body extracted from the SQS message using the parameter. 
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP40.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP41.png" width="700"  title="hover text">
 </p>
<p align="center">
  <p align="center">
  Go back to the lambda function that was made and add a trigger. The trigger will be SQS. Enter the ARN of the SQS queue. Select Activate trigger. 
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP42.png" width="700"  title="hover text">
 </p>
 <p align="center">
 Create s3 bucket so Kinesis Firehouse can store the data.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP43.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to Kinesis Data Firehose and create a delivery stream. Direct PUT will be the source because it will be in putting the data in S3, the destination. You can change the name if you like.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP44.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Choose the S3 bucket that was created.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP45.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Choose the buffer parameters 
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP46.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to Lambda and create another one, this time for the Kafka Consumer.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP47.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Input the code and click Deploy.
   This code is designed to process events from the Consumer function into Kinesis Firehouse, then it will stream data into S3 bucket to      store. </p>
  <p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP48.png" width="700"  title="hover text">
 </p>
  <p align="center">
  I chose 4 min for timeout. Here select an IAM role that will allow access. Open new tab and add policies to the existing role. Do that in the follow images.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP49.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP50.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Now we are going to create one public and one private ec2 to use to ping private MSK cluster to public subnet using its NAT Gateway. Here is the public one. Choose public subnet and make sure to choose the VPC that was created earlier. 
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP51.png" width="700"  title="hover text">
 </p>
 <p align="center">
  This is the private EC2 instance. Make sure the subnet choosen is the private one.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP53.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Choose security group of private EC2. Allow All Traffic from MSK cluster to EC2 in private subnet. Allow SSH also. Add security group of MSK cluster here.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP54.png" width="700"  title="hover text">
 </p>
 Go to security group of MSK cluster and allow traffic from private ec2 instance and itself. Make sure it says All. on both port ranges. ignore the 0 in the picture.
 </p>
 <p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP55.png" width="700"  title="hover text">
 </p>
 <p align="center">
  SSH into public ec2 instance.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP56.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to the MSK cluster to the bootstrap servers that will establish a connection. 
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP57.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Go to the KafkaProducer lambda and insert it into the code. Click Deploy.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP58.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Move the pem key of the private ec2 into the public ec2. This is how I did it using FileZilla.
  </p>
 <p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP59.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Here you can see the public ec2 that we connect to has the pem file of the private ec2, SSH into the priavte ec2 by way of the public ec2.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP60.png" width="700"  title="hover text">
 </p>
 <p align="center">
  ping to see if the conenction is working. Install java and Kafka after this.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP61.png" width="700"  title="hover text">
 </p>
 <p align="center">
  After installing java and kafka onto this private ec2 instance use this sh command to create a kafka topic. Insert your MSK bootstrap servers that you copied earlier after the bootstrap flag.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP62.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP63.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Put the sh command to add the kafka consumer.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP64.png" width="700"  title="hover text">
 </p>
 Go to kafka consumer lambda and add MSK as a trigger. Insert the topic name of the kafka consumer.
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP65.png" width="700"  title="hover text">
 </p>
 <p align="center">
  I went to postman, Created a POST with the API Gateway. You can see the messages being pubslihed to the SQS queue.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP67.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP68.png" width="700"  title="hover text">
 </p>
  <p align="center">
  The CloudWatch logs you can see the lambda producer requests
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP69.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Here you can see the Consumer lambda logs
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP70.png" width="700"  title="hover text">
 </p>
 <p align="center">
  You can see the S3 bucket storing the PUTS of the Kinesis Firehose streams.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP71.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Here, its not required but Go to Glue and create a crawler.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP72.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Create a table and a database.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP73.png" width="700"  title="hover text">
 </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP74.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Run the crawler and create a table
  </p>
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP75.png" width="700"  title="hover text">
 </p>
 <p align="center">
  Allow Athena to query or peeform any task you would like. here is just a quick example of the from of events that you can add in your pipeline.
  </p>
<p align="center">
  <img src="https://raw.githubusercontent.com/KaityLeG/AWS_MSK_DataPipeline/main/images/MSKDP76.png" width="700"  title="hover text">
 </p>
 <p align="center">
  This is the end of this pipeline. It is editable and of course there are many ways to go about this
  </p>

