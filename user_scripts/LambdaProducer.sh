from time import sleep
from json import dumps
from kafka import KafkaProducer
import json

topic_name='{Provide the topic name here}'
producer = KafkaProducer(bootstrap_servers=['{Put the broker URLs here}'
,'{Put the broker URLs here}'],value_serializer=lambda x: dumps(x).encode('utf-8'))

def lambda_handler(event, context):
    print(event)
    for i in event['Records']:
        sqs_message =json.loads((i['body']))
        print(sqs_message)
        producer.send(topic_name, value=sqs_message)
    
    producer.flush()
	
