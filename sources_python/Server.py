
import socket
import struct

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((socket.gethostname(), 8080))
server.listen(5)


while True:
    connection, address = server.accept()

    while True:
        eth_packet = connection.recv(2048)
        if not eth_packet:
            break
        connection.send(str.encode('data accepted by server successfully'))
    connection.close()
    print('client disconnected')
