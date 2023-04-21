import select
import queue

def msgChecker(isChecking, socket, buffer_size):
        inputCheck = {}
        outputCheck = {}
        isAcquiring = False  
        msgQueue = queue.Queue()

        while isChecking:
            readable, writable, exceptional = select.select(inputCheck, outputCheck, inputCheck)
            for s in readable:
                message = s.recv(buffer_size)
                if not isAcquiring:
                    print(message)
                    inputCheck = []
                else:
                    print(message)
                    
            for s in writable:
                try:
                    next_msg = msgQueue.get_nowait()
                except queue.Empty:
                    pass
                else:
                    # print("send ")
                    socket.send(str(next_msg).encode())

            for s in exceptional:
                print("exceptional ", s)
