import Foundation


struct Matchgarden {
    
    enum State {
        
        case empty
        case onePlayerRequesting(ServerPlayer)
        case matchStarted(ServerMatch)
        case matching(ServerMatch)
    }
    
    var state: State
    
    init() {
        state = .empty
    }
    
    mutating func reset() {
        state = .empty
    }
    
    mutating func handle(request: Request) -> Data {
        switch request.type {
        case .players:
            var response = Response(domain: .players)
            switch state {
            case .matching(let match):
                response.players = Array(match.players)
            case .matchStarted(let match):
                response.players = Array(match.players)
            default: break
            }
            return encode(request: response)
        case .pingServer:
            var response = Response(domain: .serverState)
            switch state {
            case .empty: response.serverState = .hold
            case .onePlayerRequesting: response.serverState = .creatingMatch
            case .matchStarted: response.serverState = .matchStarted
            case .matching: response.serverState = .matching
            }
            response.text = "\(state)"
            return encode(request: response)
        case .needMatch:
            switch state {
            case .empty: 
                state = .onePlayerRequesting(request.player)
                var response = Response(domain: .serverState)
                response.serverState = .creatingMatch
                response.text = "\(state)"
                return encode(request: response)
            case .onePlayerRequesting(let waitingplayer):
                let first = request.player
                let second = waitingplayer
                let match = ServerMatch(players: [first, second])
                state = .matchStarted(match)
                var response = Response(domain: .serverState)
                response.serverState = .matchStarted
                response.text = "\(state)"
                response.players = Array(match.players)
                return encode(request: response)
            case .matchStarted(let match):
                state = .matching(match)
                var response = Response(domain: .serverState)
                response.serverState = .matching
                response.text = "\(state)"
                response.players = Array(match.players)
                return encode(request: response)
            case .matching(let match):
                var players = match.players
                players.insert(request.player)
                let updatematch = ServerMatch(players: players)
                state = .matching(updatematch)
                var response = Response(domain: .serverState)
                response.serverState = .matching
                response.text = "\(state)"
                response.players = Array(match.players)
                return encode(request: response)
            }
        case .takeYourMatchData:
            switch state {
            case .matchStarted(let match):
                state = .matching(match)
                var response = Response(domain: .serverState)
                let gamedata = GameData(owner: request.player, data: request.data!)
                response.gameData = gamedata
                response.serverState = .matching
                return encode(request: response)
            case .matching:
                var response = Response(domain: .serverState)
                let gamedata = GameData(owner: request.player, data: request.data!)
                response.gameData = gamedata
                response.serverState = .matching
                return encode(request: response)
            default: 
                let response = Response(domain: .error)
                print("no match")
                return encode(request: response)
            }
        case .disconnectMe:
            reset()
            var response = Response(domain: .serverState)
            response.serverState = .matchFinished
            return encode(request: response)
        }
    }
    
    mutating func command(from data: Data) -> Data {
        do {
            let request = try JSONDecoder().decode(Request.self, from: data)
            return handle(request: request)
        } catch let error {
            print("here")
            assertionFailure("\(error)")
            return Data()
//            var response = Response(domain: .error)
//            print("here")
//            print("error: \(error)")
//            let string = String(bytes: data, encoding: .utf8)
//            print("data: \(string as Any)")
//            response.text = "\(error)"
//            return encode(request: response)
        }
    }
    
    func encode<Item: Codable>(request: Item) -> Data {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(request)
        return data
    }
    
}
