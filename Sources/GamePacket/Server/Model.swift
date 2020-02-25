import Foundation


struct Matchgarden {
    
    enum State {
        case empty
        case onePlayerRequesting(ServerPlayer)
        case matching(ServerMatch)
        var network: ServerStatus {
            switch self {
            case .empty: return .hold
            default: return .creatingMatch
            }
        }
    }
    
    var state: State
    
    init() {
        state = .empty
    }
    
    mutating func command(from data: Data) -> Data {
        let request = try! JSONDecoder().decode(Request.self, from: data)
        print("incoming request: \(request)")
        switch request.type {
        case .pingServer:
            var responce = Response(domain: .serverStatus)
            responce.status = state.network
            return encode(request: responce)
        case .needMatch:
            switch state {
            case .empty: break
            case .matching(let match): break
            case .onePlayerRequesting(let waitingplayer):
                let match = ServerMatch(players: [waitingplayer, request.player])
                let out = State.matching(match)
                state = out
                var responce = Response(domain: .matchCreatedWaitingPlayers)
                responce.status = state.network
                return encode(request: responce)
            }
            fallthrough
        default:
            let responce = Response(domain: .error)
            return encode(request: responce)
        }
        
    }
    
    func encode<Item: Codable>(request: Item) -> Data {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(request)
        return data
    }
    
}
