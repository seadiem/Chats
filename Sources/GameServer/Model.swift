import Foundation
import Packet


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
            let responce = Response(domain: .error)
            return encode(request: responce)
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
