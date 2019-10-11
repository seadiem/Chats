import ChatYard
import Foundation
import Packet

struct App {
    
    struct Player {
        let name: String
    }

    
    let player: Player
    let client: Client
    
    
    init() {
        player = Player(name: "Ivan")
        client = Client()
    }
    
    func play() {
        while true {
            let line = readLine()
            guard let command = line else { return }
            print(command)
        }
    }
    
}
    


struct Client {
    
    func run() {

        let client = try! ChatClientData(name: "First") { data in
            let packet = try! JSONDecoder().decode(Response.self, from: data)
            print(packet)
        }
        
        let queue = DispatchQueue(label: "socket listener")
        queue.async {
            client.listen()
        }
        
        func send<Item: Codable>(request: Item) {
            let encoder = JSONEncoder()
            let data = try! encoder.encode(request)
            client.send(data: data)
        }
        
        while true {
            let line = readLine()
            guard let command = line else { return }
            switch command {
            case "ping": break
//                let request = Request(type: .pingServer)
//                send(request: request)
            default: break
            }
        }
    }
}


public struct ChatClientData {
    
    let name: String
    let leash: Leash
    let handler: (Data) -> Void
    
    public init(name: String, handler: @escaping (Data) -> Void) throws {
        self.name = name
        self.leash = try Leash()
        self.handler = handler
    }
    
    public func send(data: Data) {
        do { try leash.clientSocket.write(from: data) }
        catch let error { print(error) }
    }
    
    public func listen() {
        while true {
            do {
                var data = Data()
                _ = try self.leash.clientSocket.read(into: &data)
                self.handler(data)
            } catch let error {
                print(error)
            }
        }
    }
}
