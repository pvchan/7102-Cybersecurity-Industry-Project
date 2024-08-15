import paho.mqtt.client as mqtt
import time

# MQTT Broker details
broker = "192.168.20.4"
port = 1883
topic = "factory/chlorine_level"
message = "flood"
username = "admin"
password = "admin123"


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected with result code 0 - Connection successful")
    else:
        print(f"Connection failed with result code {rc}")


# Create an MQTT client instance
client = mqtt.Client()

# Set username and password
client.username_pw_set(username, password)

# Attach the on_connect callback function
client.on_connect = on_connect

# Connect to the MQTT broker
client.connect(broker, port, 60)

# Start the loop to process network traffic, callbacks, and reconnecting
client.loop_start()

# Publish messages continuously
try:
    while True:
        client.publish(topic, message)
        print(f"Published message: {message} to topic: {topic}")
        time.sleep(0.1)  # Adjust sleep to control the flood rate
except KeyboardInterrupt:
    print("Interrupted by user")
finally:
    client.loop_stop()
    client.disconnect()
    print("Disconnected from broker")
