import ChatYard
import Foundation

public struct NetworkApp {

    
    let player: ServerPlayer
    var match: ServerMatch?
    let client: ChatClientData
    
    
    public init() throws {
        print("input name:")
        let name = readLine()
        player = ServerPlayer(name: name!)
        client = try ChatClientData() { data in 
            let decoder = JSONDecoder()
            let response = try! decoder.decode(Response.self, from: data)
            print("response: \(response)")
        }
    }
    
    public func listen() {
        DispatchQueue.global().async {
            self.client.listen()
        }
    }
    
    public func send(command: String) {
        switch command {
        case "ping":
            let request = Request(type: .pingServer, player: player)
            let data = try! JSONEncoder().encode(request)
            client.send(data: data)
        case "need match":
            let request = Request(type: .needMatch, player: player)
            let data = try! JSONEncoder().encode(request)
            client.send(data: data)
        case "game data":
            var request = Request(type: .takeYourMatchData, player: player)
            request.data = "Gameplay".data(using: .utf8)
            let data = try! JSONEncoder().encode(request)
            client.send(data: data)
        default: break }
    }
    
    public func send(game data: Data) {
        var request = Request(type: .takeYourMatchData, player: player)
        request.data = data
        let outdata = try! JSONEncoder().encode(request)
        client.send(data: outdata)
    }
    
    public func startKeyboard() {
        while true {
            print("input command...")
            let line = readLine()
            guard let command = line else { return }
            send(command: command)
        }
    }
    
    public func play() {
        listen()
        startKeyboard()
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
            let app = try NetworkApp()
            app.play()
        } catch let error {
            print(error)
        }
    }
}
