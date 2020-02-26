import Foundation


struct Matchgarden {
    
    enum State {
        
        case empty
        case onePlayerRequesting(ServerPlayer)
        case matching(ServerMatch)
        
        var response: Response {
            switch self {
            case .empty:
                var response = Response(domain: .gameState)
                response.status = ServerStatus.hold
                return response
            case .matching(_):
                var response = Response(domain: .gameState)
                response.status = ServerStatus.matching
                return response
            case .onePlayerRequesting:
                var response = Response(domain: .gameState)
                response.status = ServerStatus.creatingMatch
                return response
            }
        }
    }
    
    var state: State
    
    init() {
        state = .empty
    }
    
    mutating func reset() {
        state = .empty
    }
    
    mutating func command(from data: Data) -> Data {
        let request = try! JSONDecoder().decode(Request.self, from: data)
        switch request.type {
        case .pingServer:
            var response = Response(domain: .textMessage)
            response.text = "\(state)"
            return encode(request: response)
        case .needMatch:
            switch state {
            case .empty: 
                state = .onePlayerRequesting(request.player)
                return encode(request: state.response)
            case .onePlayerRequesting(let waitingplayer):
                let first = request.player
                let second = waitingplayer
                let match = ServerMatch(players: [first, second])
                state = .matching(match)
                return encode(request: state.response)
            case .matching(let match):
                var players = match.players
                players.insert(request.player)
                let updatematch = ServerMatch(players: players)
                state = .matching(updatematch)
                return encode(request: state.response)
            }
        case .takeYourMatchData:
            switch state {
            case .matching:
                var response = Response(domain: .gameState)
                let gamedata = GameData(owner: request.player, data: request.data!)
                response.gameData = gamedata
                return encode(request: response)
            default: 
                let response = Response(domain: .error)
                print("no match")
                return encode(request: response)
            }
        }
        
    }
    
    func encode<Item: Codable>(request: Item) -> Data {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(request)
        return data
    }
    
}
