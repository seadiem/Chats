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
                                
                                // Если сокет говорит, что ждёт матч, и на сервере уже есть тот, кто ждёт матч,
                                // то создаём матч и и отсылаем ответ всем сокетам, что матч создан.
                                
                                
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
                case "reset": break
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
                case "need match":
                    let player = ServerPlayer(name: "Zaur")
                    let request = Request(type: .needMatch, player: player)
                    _ = model.command(from: try! JSONEncoder().encode(request))
                    print("try to need match")
                case "ping":
                    let player = ServerPlayer(name: "Ivan")
                    let request = Request(type: .pingServer, player: player)
                    let dataanswer = model.command(from: try! JSONEncoder().encode(request))
                    let decoder = JSONDecoder()
                    let response = try! decoder.decode(Response.self, from: dataanswer)
                    print("response: \(response)")
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
                print("socket was appended")
            }
        } catch let error {
            print(error)
        }
        
    }
    
}
