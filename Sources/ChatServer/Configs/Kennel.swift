import Socket
import Foundation
import ChatYard

public struct ServerData {
    
    var sockets = [Socket]() {
        didSet {
            for socket in sockets {
                adjust(socket: socket)
            }
        }
    }
    
    public init() {}
    
    func adjust(socket: Socket) {
        
        let socketsbrowcast = DispatchQueue(label: "\(socket.socketfd)")
        socketsbrowcast.async {
            while true {
                do {
                    var data = Data()
                    _ = try socket.read(into: &data)
                    
                    for item in self.sockets {
                        try item.write(from: data)
                    }
                    
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    mutating public func start() {
        
        do {
            let kennel = try Kennel { $0 ?? "no text" }
            print("wait client socket...")
            meetsocket: while true {
                let newSocket = try kennel.serverSocket.acceptClientConnection() // ждём клиент
                sockets.append(newSocket)
            }
        } catch let error {
            print(error)
        }
        
    }
    
}


public struct ServerDataOneFunction {
    
    public init() {}
    public func start() {
        
        var sockets = [Socket]() {
            didSet {
                for item in sockets {
                    let socketsbrowcast = DispatchQueue(label: "\(item.socketfd)")
                    socketsbrowcast.async {
                        while true {
                            do {
                                
                                var data = Data()
                                _ = try item.read(into: &data)
                                
                                for item in sockets {
                                    try item.write(from: data)
                                }
                            } catch let error {
                                print(error)
                            }
                        }
                    }
                }
            }
        }


        let queue = DispatchQueue(label: "keyboard listen")
        queue.async {
            
            keyinput: while true {
                print("input message...")
                let message = readLine()
                guard let line = message else { continue keyinput }
                for item in sockets {
                    do {
                        
                        let bee = YardMessage(from: "Moderator", text: line)
                        let encoder = JSONEncoder()
                        let data = try! encoder.encode(bee)
                        
                        try item.write(from: data)
                    } catch let error {
                        print(error)
                        continue keyinput
                    }
                }
            }
        }



        do {
            let kennel = try Kennel { $0 ?? "no text" }
            print("wait client socket...")
            meetsocket: while true {
                let newSocket = try kennel.serverSocket.acceptClientConnection() // ждём клиент
                sockets.append(newSocket)
            }
        } catch let error {
            print(error)
        }
        
    }
    
}
