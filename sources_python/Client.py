import socket
import time
from sources_python.create_packets import *



client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((socket.gethostname(), 8080))
client.settimeout(3)
time.sleep(3)

create_random_ips(ips, 8)
created_packets = create_random_packets(ips, 500)
for packet in created_packets:
    client.send(bytes(created_packets[0]))
    fromServer = client.recv(2048)
    fromServer = fromServer.decode('utf-8')
    print(fromServer)

client.close()
