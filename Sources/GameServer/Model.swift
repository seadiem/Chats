import Foundation
import Packet


struct Matchgarden {
    
    enum State {
        case empty
        case onePlayerRequesting(ServerPlayer)
        case matching(ServerMatch)
    }
    
    var state: State {
        didSet {
            switch state {
            case .matching(let match): _ = 6
            default: break
            }
        }
    }
    
    init() {
        state = .empty
    }
    
    mutating func request(from player: ServerPlayer) {
        switch state {
        case .empty: state = .onePlayerRequesting(player)
        case .onePlayerRequesting(let other):
            let match = ServerMatch(players: [player, other])
            state = .matching(match)
        default: break
        }
    }
    
    func decode(data: Data) {
        
    }
    
}
