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
