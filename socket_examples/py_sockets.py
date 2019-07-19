#!/usr/bin/env python3

import socket

PORT = 8080
IP = '127.0.0.1'

# Create a socket object with a TCP nature
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    # bind our socket to port 8080
    s.bind(('127.0.0.1', 8080))

    # listen for incoming connections
    s.listen(30)

    # accept a connection
    conn, addr = s.accept()
    try:
        with conn:
            print('Connected by', addr)

            # continuously recieve data in 1024 byte increments
            while True:
                data = conn.recv(1024)
                if not data:
                    continue
                data = 'Got: ' + str(data)
                print(data)
                conn.sendall(bytes(data, 'utf-8'))

    except Exception as err:
        print(err)
        conn.close()

