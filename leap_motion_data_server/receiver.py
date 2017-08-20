import pika
import json
import numpy as np
import tensorflow as tf

def callback(ch, method, properties, body):
	print(" [x] Receveived %d Kb data" % (len(body) / 1000))
	data = json.loads(body.decode("utf-8"))

	# Insert data into file.
	array = np.append(data.get('frameImages', []), data['keyCode'])
	print(array)

	tf.python_io.TFRecordWriter('

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()
channel.queue_declare(queue='hello')
channel.basic_consume(callback,
											queue='hello',
											no_ack=True)

print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()
