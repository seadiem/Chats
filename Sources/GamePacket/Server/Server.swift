import Socket
import Foundation
import ChatYard

public struct ServerDataOneFunction {
    
    public init() {}
    public func start() {
        
        var model = Matchgarden()
        
        
        var sockets = [Socket]() {
            didSet {
                for item in sockets {
                    let socketsbrowcast = DispatchQueue(label: "\(item.socketfd)")
                    socketsbrowcast.async {
                        while true {
                            do {
                                
                                var data = Data()
                                _ = try item.read(into: &data)
                                
              
                                let response = model.command(from: data)
                                
                                for item in sockets {
                                    try item.write(from: response)
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
                print("input command:")
                let message = readLine()
                guard let line = message else { continue keyinput }
                switch line {
                case "send text":
                    print("input message to send:")
                    let texttosend = readLine()
                    guard let unwraptext = texttosend else { continue keyinput }
                    var messageResponse = Response(domain: .textMessage)
                    messageResponse.text = "text from Moderator: \(unwraptext)"
                    let encoder = JSONEncoder()
                    let data = try! encoder.encode(messageResponse)
                    for item in sockets {
                        do {
                            try item.write(from: data)
                        } catch let error {
                            print(error)
                            continue keyinput
                        }
                    }
                case "create match": 
                    print("try to create match")
                default: break
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
