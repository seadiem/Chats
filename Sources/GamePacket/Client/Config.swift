import ChatYard
import Foundation

public struct NetworkApp {

    
    let player: ServerPlayer
    var match: ServerMatch?
    let client: ChatClientData
    
    
    public init(listener: @escaping (Response) -> Void) throws {
        print("input name:")
        let name = readLine()
        let player = ServerPlayer(name: name!)
        client = try ChatClientData() { data in 
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(Response.self, from: data)
                switch response.domain {
                case .serverState:
                    switch response.serverState {
                    case .matching:
                        guard let gamedata = response.gameData else { print("no game data"); break }
                        if gamedata.owner != player { listener(response) }
                    default: listener(response)
                    }
                default: listener(response)
                }
            } catch let error {
                print(error)
                guard let string = String(bytes: data, encoding: .utf8) else { return }
                print("string: \(string)")
            }
        }
        self.player = player
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
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let outdata = try encoder.encode(request)
            client.send(data: outdata)
        } catch {
            print("coding error")
        }
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
            let app = try NetworkApp { _ in }
            app.play()
        } catch let error {
            print(error)
        }
    }
}
