import json
import pika

from flask import Flask
from flask import request

app = Flask(__name__)

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()
channel.queue_declare(queue='hello')

@app.route("/enqueue", methods=['GET', 'POST'])
def enqueue():
	print(request.headers)
	print(request.data)

	json_data = json.loads(request.data.decode("utf-8"))
	channel.basic_publish(exchange='',
											  routing_key='hello',
												body=request.data)

	print(" [x] Enqueued request data")
	return "Hello World"

if __name__ == "__main__":
	app.run(debug=True)
	connection.close()
