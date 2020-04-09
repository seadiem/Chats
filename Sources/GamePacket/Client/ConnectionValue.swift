import ChatYard
import Foundation

struct App {
    func work() {
        var connection = try! Connection()
        connection.listener = { _ in
            connection.send(command: "") 
        }
    }
}

public struct Connection {
    
    let player: ServerPlayer
    var match: ServerMatch?
    let leash: Leash
    public var listener: ((Response) -> Void)?
    
    
    public init(inputname: String? = nil) throws {
        
        let player: ServerPlayer
        
        if let unwrapname = inputname {
            player = ServerPlayer(name: unwrapname)
        } else {
            print("input name:")
            let name = readLine()
            player = ServerPlayer(name: name!)
        }
        
        self.player = player
        self.leash = try Leash()
    }
    
    
    public func listen() {
        while true {
            do {
                var data = Data()
                _ = try self.leash.clientSocket.read(into: &data)
                handleDryData(data: data)
            } catch let error {
                print(error)
            }
        }
    }
    
    func handleDryData(data: Data) {
        
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Response.self, from: data)
            switch response.domain {
            case .serverState:
                switch response.serverState {
                case .matching, .matchStarted:
                    guard let gamedata = response.gameData else { print("no game data"); fallthrough }
                    if gamedata.owner != player { listener?(response) }
                default: listener?(response)
                }
            default: listener?(response)
            }
        } catch let error {
            print(error)
            guard let string = String(bytes: data, encoding: .utf8) else { return }
            print("string: \(string)")
        }
        
    }
    
    public func send(command: String) {
        switch command {
        case "ping":
            let request = Request(type: .pingServer, player: player)
            let data = try! JSONEncoder().encode(request)
            sendDry(data: data)
        case "need match":
            let request = Request(type: .needMatch, player: player)
            let data = try! JSONEncoder().encode(request)
            sendDry(data: data)
        case "game data":
            var request = Request(type: .takeYourMatchData, player: player)
            request.data = "Gameplay".data(using: .utf8)
            let data = try! JSONEncoder().encode(request)
            sendDry(data: data)
        default: break }
    }
    
    public func send(game data: Data) {
        var request = Request(type: .takeYourMatchData, player: player)
        request.data = data
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let outdata = try encoder.encode(request)
            sendDry(data: outdata)
        } catch {
            print("coding error")
        }
    }
    
    func sendDry(data: Data) {
        do { try leash.clientSocket.write(from: data) }
        catch let error { print(error) }
    }
    
}
