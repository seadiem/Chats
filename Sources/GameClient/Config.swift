import ChatYard
import Foundation
import Packet

struct App {

    
    let player: ServerPlayer
    var match: ServerMatch?
    let client: ChatClientData
    
    
    init() throws {
        player = ServerPlayer(name: "Ivan")
        client = try ChatClientData() { data in 
            let decoder = JSONDecoder()
            let response = try! decoder.decode(Response.self, from: data)
            print("response: \(response)")
        }
    }
    
    func play() {
        
        DispatchQueue.global().async {
            self.client.listen()
        }
        
        while true {
            print("input command...")
            let line = readLine()
            guard let command = line else { return }
            switch command {
            case "ping":
                let request = Request(type: .pingServer, player: player)
                let data = try! JSONEncoder().encode(request)
                client.send(data: data)
            default: break
            }
        }
        
    }
}

public struct ChatClientData {
    
    let leash: Leash
    let listener: (Data) -> Void
    
    public init(listener: @escaping (Data) -> Void) throws {
        self.leash = try Leash()
        self.listener = listener
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
                self.listener(data)
            } catch let error {
                print(error)
            }
        }
    }
}

struct AppTest {
    func run() {
        do {
            let app = try App()
            app.play()
        } catch let error {
            print(error)
        }
    }
}
